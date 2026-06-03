//
//  SearchPlanExecutor.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Executes a ``SearchPlan`` deterministically against TMDb services.
///
/// The executor performs all name-to-identifier resolution, filtering, and
/// shaping in code. It never invokes the language model, so its behaviour is
/// fully testable.
///
struct SearchPlanExecutor {

    let dataSource: any NaturalLanguageSearchDataSource
    let now: @Sendable () -> Date
    let resultLimit: Int

    init(
        dataSource: some NaturalLanguageSearchDataSource,
        resultLimit: Int = 20,
        now: @escaping @Sendable () -> Date = { Date() }
    ) {
        self.dataSource = dataSource
        self.now = now
        self.resultLimit = resultLimit
    }

    ///
    /// Executes a plan and returns the matching entities.
    ///
    /// - Parameter plan: The plan to execute.
    ///
    /// - Throws: ``NaturalLanguageSearchError/outOfScope`` if the plan is not in
    ///   scope; otherwise an error from the underlying data source.
    ///
    /// - Returns: The matching movies, TV series, and people.
    ///
    func execute(_ plan: SearchPlan) async throws -> NaturalLanguageSearchResult {
        guard plan.isInScope else {
            throw NaturalLanguageSearchError.outOfScope
        }

        var degradations: [SearchDegradation] = []

        switch plan.intent {
        case .castOf:
            return try await executeCastOf(plan)

        case .crewRole where plan.title != nil:
            return try await executeCrewRole(plan)

        case .similar where plan.title != nil:
            return try await executeSimilar(plan, degradations: &degradations)

        case .list:
            return try await executeList(plan)

        case .browse, .byPerson, .mood, .crewRole, .similar:
            return try await executeDiscover(plan, degradations: &degradations)
        }
    }

}

// MARK: - People-returning intents

extension SearchPlanExecutor {

    private func executeCastOf(_ plan: SearchPlan) async throws -> NaturalLanguageSearchResult {
        guard let credits = try await credits(forTitle: plan) else {
            return NaturalLanguageSearchResult(interpretation: plan.title)
        }

        return NaturalLanguageSearchResult(
            interpretation: plan.title,
            people: cap(dedupe(credits.cast.map(person(from:))))
        )
    }

    private func executeCrewRole(_ plan: SearchPlan) async throws -> NaturalLanguageSearchResult {
        guard let credits = try await credits(forTitle: plan) else {
            return NaturalLanguageSearchResult(interpretation: plan.title)
        }

        let matching: [CrewMember] = if let role = plan.crewRole?.lowercased() {
            credits.crew.filter { $0.job.lowercased() == role }
        } else {
            credits.crew
        }

        return NaturalLanguageSearchResult(
            interpretation: plan.title,
            people: cap(dedupe(matching.map(person(from:))))
        )
    }

}

// MARK: - Similar

extension SearchPlanExecutor {

    private func executeSimilar(
        _ plan: SearchPlan,
        degradations: inout [SearchDegradation]
    ) async throws -> NaturalLanguageSearchResult {
        let bounds = plan.date.map(yearBounds(for:))

        if plan.mediaType == .tv {
            return try await executeSimilarTVSeries(plan, bounds: bounds, degradations: &degradations)
        }

        guard let id = try await dataSource.searchMovies(query: plan.title ?? "").first?.id else {
            return NaturalLanguageSearchResult(interpretation: plan.title)
        }

        var movies = try await dataSource.similarMovies(toMovie: id)
        movies = filterByYear(movies, bounds: bounds, date: { $0.releaseDate })
        movies = applyExclusions(movies, plan: plan, name: { $0.title }, into: &degradations)
        return NaturalLanguageSearchResult(
            interpretation: plan.title,
            movies: cap(dedupe(movies)),
            degradations: degradations
        )
    }

    private func executeSimilarTVSeries(
        _ plan: SearchPlan,
        bounds: (from: Int, to: Int)?,
        degradations: inout [SearchDegradation]
    ) async throws -> NaturalLanguageSearchResult {
        guard let id = try await dataSource.searchTVSeries(query: plan.title ?? "").first?.id else {
            return NaturalLanguageSearchResult(interpretation: plan.title)
        }

        var series = try await dataSource.similarTVSeries(toTVSeries: id)
        series = filterByYear(series, bounds: bounds, date: { $0.firstAirDate })
        series = applyExclusions(series, plan: plan, name: { $0.name }, into: &degradations)
        return NaturalLanguageSearchResult(
            interpretation: plan.title,
            tvSeries: cap(dedupe(series)),
            degradations: degradations
        )
    }

}

// MARK: - Lists

extension SearchPlanExecutor {

    private func executeList(_ plan: SearchPlan) async throws -> NaturalLanguageSearchResult {
        guard let kind = plan.list else {
            var degradations: [SearchDegradation] = []
            return try await executeUnderspecified(plan, degradations: &degradations)
        }

        switch plan.mediaType {
        case .person:
            return try await NaturalLanguageSearchResult(
                interpretation: plan.interpretationText,
                people: cap(dataSource.trendingPeople())
            )

        case .tv:
            return try await NaturalLanguageSearchResult(
                interpretation: plan.interpretationText,
                tvSeries: cap(dataSource.curatedTVSeries(kind))
            )

        case .movie, .none:
            return try await NaturalLanguageSearchResult(
                interpretation: plan.interpretationText,
                movies: cap(dataSource.curatedMovies(kind))
            )
        }
    }

    private func executeUnderspecified(
        _ plan: SearchPlan,
        degradations: inout [SearchDegradation]
    ) async throws -> NaturalLanguageSearchResult {
        degradations.append(.underspecified)
        return try await NaturalLanguageSearchResult(
            interpretation: plan.interpretationText,
            movies: cap(dataSource.curatedMovies(.popular)),
            degradations: degradations
        )
    }

}

// MARK: - Discover (browse / byPerson / mood)

extension SearchPlanExecutor {

    private func executeDiscover(
        _ plan: SearchPlan,
        degradations: inout [SearchDegradation]
    ) async throws -> NaturalLanguageSearchResult {
        let inputs = try await resolveInputs(for: plan, into: &degradations)

        let nothingResolved = inputs.genreIDs.isEmpty && inputs.companyIDs.isEmpty
            && inputs.personIDs.isEmpty && inputs.bounds == nil && inputs.minRating == nil
            && plan.runtimeMaxMinutes == nil
        // When nothing resolved (including a `.byPerson` plan whose people all
        // failed to resolve), degrade rather than issuing an unconstrained
        // discover that would return a broad popularity dump.
        if nothingResolved {
            return try await executeUnderspecified(plan, degradations: &degradations)
        }

        if plan.mediaType == .tv {
            let filter = tvFilter(plan: plan, inputs: inputs)
            var series = try await dataSource.discoverTVSeries(filter: filter, sortedBy: nil)
            series = applyExclusions(series, plan: plan, name: { $0.name }, into: &degradations)
            return NaturalLanguageSearchResult(
                interpretation: plan.interpretationText,
                tvSeries: cap(dedupe(series)),
                degradations: degradations
            )
        }

        let filter = movieFilter(plan: plan, inputs: inputs)
        var movies = try await dataSource.discoverMovies(filter: filter, sortedBy: nil)
        movies = applyExclusions(movies, plan: plan, name: { $0.title }, into: &degradations)
        return NaturalLanguageSearchResult(
            interpretation: plan.interpretationText,
            movies: cap(dedupe(movies)),
            degradations: degradations
        )
    }

}
