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
    func execute(_ rawPlan: SearchPlan) async throws -> NaturalLanguageSearchResult {
        guard rawPlan.isInScope else {
            throw NaturalLanguageSearchError.outOfScope
        }

        let plan = Self.normalize(rawPlan)
        var degradations: [SearchDegradation] = []

        switch plan.intent {
        case .find:
            return try await executeFind(plan)

        case .castOf:
            return try await executeCastOf(plan)

        case .crewRole where plan.title != nil:
            return try await executeCrewRole(plan)

        case .similar where plan.title != nil:
            return try await executeSimilar(plan, degradations: &degradations)

        case .list:
            return try await executeList(plan)

        // `.crewRole` / `.similar` without a title can't look up credits or
        // recommendations, so they deliberately fall through to the discover path.
        case .browse, .byPerson, .mood, .crewRole, .similar:
            return try await executeDiscover(plan, degradations: &degradations)
        }
    }

    ///
    /// Repairs a common planner mistake: a person query (e.g. "Brad Pitt
    /// movies") is often tagged `find`/`browse` while the person is still
    /// correctly placed in `people`. Since only `byPerson` uses `people`, a
    /// populated `people` field means the request is really `byPerson`.
    ///
    static func normalize(_ plan: SearchPlan) -> SearchPlan {
        // A person query ("Brad Pitt movies", "films Bruce Willis has been in") is
        // often tagged find/browse, with the person in `people` and the title either
        // empty or echoing the prompt (e.g. title="popular films bruce willis has
        // been in"). A genuine bare-title find ("Fight Club") has a clean title that
        // does NOT mention the listed people (any `people` there is an invented cast,
        // which find ignores). So coerce to byPerson only when there is a real person
        // name and the title is empty or contains one of those names.
        let names = plan.people.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        guard !names.isEmpty, plan.intent == .find || plan.intent == .browse else {
            return plan
        }

        let title = (plan.title ?? "").trimmingCharacters(in: .whitespaces)
        let titleEchoesPerson = names.contains { title.localizedCaseInsensitiveContains($0) }
        guard title.isEmpty || titleEchoesPerson else {
            return plan
        }

        return SearchPlan(
            intent: .byPerson,
            isInScope: plan.isInScope,
            mediaType: plan.mediaType,
            title: plan.title,
            people: names,
            crewRole: plan.crewRole,
            genres: plan.genres,
            excludeTitles: plan.excludeTitles,
            companies: plan.companies,
            moodTerm: plan.moodTerm,
            date: plan.date,
            runtimeMaxMinutes: plan.runtimeMaxMinutes,
            minRating: plan.minRating,
            list: plan.list
        )
    }

}

// MARK: - Find (direct title/name lookup)

extension SearchPlanExecutor {

    private func executeFind(_ plan: SearchPlan) async throws -> NaturalLanguageSearchResult {
        let query = plan.title ?? ""
        guard !query.isEmpty else {
            return NaturalLanguageSearchResult(interpretation: plan.title)
        }

        let found = try await dataSource.searchAll(query: query)

        // Narrow to a single bucket when the model inferred a media type,
        // otherwise return movies, TV series, and people (like a multi-search).
        let movies = plan.mediaType == nil || plan.mediaType == .movie ? found.movies : []
        let tvSeries = plan.mediaType == nil || plan.mediaType == .tv ? found.tvSeries : []
        let people = plan.mediaType == nil || plan.mediaType == .person ? found.people : []

        return NaturalLanguageSearchResult(
            interpretation: plan.title,
            movies: cap(movies),
            tvSeries: cap(tvSeries),
            people: cap(people)
        )
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
            && inputs.runtimeMax == nil
        // When nothing resolved (including a `.byPerson` plan whose people all
        // failed to resolve), degrade rather than issuing an unconstrained
        // discover that would return a broad popularity dump.
        if nothingResolved {
            return try await executeUnderspecified(plan, degradations: &degradations)
        }

        // The model often invents extra operands (companies, dates, genres) that
        // AND-combine in discover and zero out the results. Try progressively
        // relaxed filters and use the first that returns anything.
        let ladder = Self.relaxationLadder(inputs)

        if plan.mediaType == .tv {
            var chosen: [TVSeriesListItem] = []
            var relaxed = false
            for (level, variant) in ladder.enumerated() {
                let filter = tvFilter(plan: plan, inputs: variant)
                let series = try await dataSource.discoverTVSeries(filter: filter, sortedBy: nil)
                if !series.isEmpty || level == ladder.count - 1 {
                    chosen = series
                    relaxed = level > 0 && !series.isEmpty
                    break
                }
            }
            if relaxed { degradations.append(.relaxedConstraints) }
            let series = applyExclusions(chosen, plan: plan, name: { $0.name }, into: &degradations)
            return NaturalLanguageSearchResult(
                interpretation: plan.interpretationText,
                tvSeries: cap(dedupe(series)),
                degradations: degradations
            )
        }

        var chosen: [MovieListItem] = []
        var relaxed = false
        for (level, variant) in ladder.enumerated() {
            let filter = movieFilter(plan: plan, inputs: variant)
            let movies = try await dataSource.discoverMovies(filter: filter, sortedBy: nil)
            if !movies.isEmpty || level == ladder.count - 1 {
                chosen = movies
                relaxed = level > 0 && !movies.isEmpty
                break
            }
        }
        if relaxed { degradations.append(.relaxedConstraints) }
        let movies = applyExclusions(chosen, plan: plan, name: { $0.title }, into: &degradations)
        return NaturalLanguageSearchResult(
            interpretation: plan.interpretationText,
            movies: cap(dedupe(movies)),
            degradations: degradations
        )
    }

    ///
    /// Builds progressively relaxed inputs: full, then dropping companies, the
    /// date window, genres, the rating floor, and finally the runtime ceiling.
    /// Only adds a step when it actually drops something, so legitimate
    /// single-constraint queries aren't re-run. Genre, rating, and runtime — the
    /// constraints closest to user intent — are relaxed last.
    ///
    static func relaxationLadder(_ inputs: ResolvedInputs) -> [ResolvedInputs] {
        var ladder = [inputs]
        var current = inputs

        if !current.companyIDs.isEmpty {
            current = current.dropping(companies: true)
            ladder.append(current)
        }
        if current.bounds != nil {
            current = current.dropping(bounds: true)
            ladder.append(current)
        }
        if !current.genreIDs.isEmpty {
            current = current.dropping(genres: true)
            ladder.append(current)
        }
        if current.minRating != nil {
            current = current.dropping(rating: true)
            ladder.append(current)
        }
        if current.runtimeMax != nil {
            current = current.dropping(runtime: true)
            ladder.append(current)
        }

        return ladder
    }

}
