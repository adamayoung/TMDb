//
//  SearchPlanExecutor+Helpers.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

// MARK: - Resolved inputs

extension SearchPlanExecutor {

    struct ResolvedInputs {
        let genreIDs: [Genre.ID]
        let companyIDs: [Company.ID]
        let personIDs: [Person.ID]
        let bounds: (from: Int, to: Int)?
        let runtimeMax: Int?
        let minRating: Double?

        /// Returns a copy with the named constraints removed (for relaxation).
        func dropping(
            companies: Bool = false,
            bounds dropBounds: Bool = false,
            genres: Bool = false,
            runtime: Bool = false,
            rating: Bool = false
        ) -> ResolvedInputs {
            ResolvedInputs(
                genreIDs: genres ? [] : genreIDs,
                companyIDs: companies ? [] : companyIDs,
                personIDs: personIDs,
                bounds: dropBounds ? nil : bounds,
                runtimeMax: runtime ? nil : runtimeMax,
                minRating: rating ? nil : minRating
            )
        }
    }

    func resolveInputs(
        for plan: SearchPlan,
        into degradations: inout [SearchDegradation]
    ) async throws -> ResolvedInputs {
        var genreNames = plan.genres
        var minRating = plan.minRating
        if let term = plan.moodTerm, let mapping = MoodLexicon.mapping(for: term) {
            genreNames += mapping.genres
            minRating = minRating ?? mapping.minRating
            degradations.append(.moodApproximated(term))
        }

        let genreIDs = try await resolveGenres(
            genreNames,
            mediaType: plan.mediaType,
            into: &degradations
        )
        let companyIDs = try await resolveCompanies(plan.companies, into: &degradations)
        let personIDs = try await resolvePeople(plan.people, into: &degradations)

        return ResolvedInputs(
            genreIDs: genreIDs,
            companyIDs: companyIDs,
            personIDs: personIDs,
            bounds: plan.date.map(yearBounds(for:)),
            runtimeMax: Self.sanitizedRuntime(plan.runtimeMaxMinutes),
            minRating: Self.sanitizedRating(minRating)
        )
    }

}

// MARK: - Resolution

extension SearchPlanExecutor {

    func resolveGenres(
        _ names: [String],
        mediaType: SearchPlan.MediaType?,
        into degradations: inout [SearchDegradation]
    ) async throws -> [Genre.ID] {
        guard !names.isEmpty else {
            return []
        }

        let genres = mediaType == .tv
            ? try await dataSource.tvSeriesGenres()
            : try await dataSource.movieGenres()

        var ids: [Genre.ID] = []
        for name in names {
            let match = genres.first { $0.name.caseInsensitiveCompare(name) == .orderedSame }
            if let match {
                ids.append(match.id)
            } else {
                degradations.append(.unresolvedGenre(name))
            }
        }

        return ids
    }

    func resolvePeople(
        _ names: [String],
        into degradations: inout [SearchDegradation]
    ) async throws -> [Person.ID] {
        var ids: [Person.ID] = []
        for name in names {
            if let match = try await dataSource.searchPeople(query: name).first {
                ids.append(match.id)
            } else {
                degradations.append(.unresolvedPerson(name))
            }
        }

        return ids
    }

    func resolveCompanies(
        _ names: [String],
        into degradations: inout [SearchDegradation]
    ) async throws -> [Company.ID] {
        var ids: [Company.ID] = []
        for name in names {
            if let match = try await dataSource.searchCompanies(query: name).first {
                ids.append(match.id)
            } else {
                degradations.append(.unresolvedCompany(name))
            }
        }

        return ids
    }

}

// MARK: - Filter building

extension SearchPlanExecutor {

    func movieFilter(plan: SearchPlan, inputs: ResolvedInputs) -> DiscoverMovieFilter {
        let usesCrew = plan.crewRole != nil
        return DiscoverMovieFilter(
            genres: inputs.genreIDs.isEmpty ? nil : inputs.genreIDs,
            primaryReleaseYear: inputs.bounds.map(primaryReleaseYear(for:)),
            voteAverageMin: Self.sanitizedRating(inputs.minRating),
            companies: inputs.companyIDs.isEmpty ? nil : inputs.companyIDs,
            runtimeMax: inputs.runtimeMax.map { RuntimeMinutes.duration(fromMinutes: $0) },
            includeAdult: false,
            withCast: (!usesCrew && !inputs.personIDs.isEmpty) ? inputs.personIDs : nil,
            withCrew: (usesCrew && !inputs.personIDs.isEmpty) ? inputs.personIDs : nil
        )
    }

    func tvFilter(plan: SearchPlan, inputs: ResolvedInputs) -> DiscoverTVSeriesFilter {
        var firstAirDateYear: Int?
        var firstAirDateMin: Date?
        var firstAirDateMax: Date?
        if let bounds = inputs.bounds {
            if bounds.from == bounds.to {
                firstAirDateYear = bounds.from
            } else {
                firstAirDateMin = startOfYear(bounds.from)
                firstAirDateMax = endOfYear(bounds.to)
            }
        }

        return DiscoverTVSeriesFilter(
            genres: inputs.genreIDs.isEmpty ? nil : inputs.genreIDs,
            firstAirDateYear: firstAirDateYear,
            firstAirDateMin: firstAirDateMin,
            firstAirDateMax: firstAirDateMax,
            voteAverageMin: Self.sanitizedRating(inputs.minRating),
            companies: inputs.companyIDs.isEmpty ? nil : inputs.companyIDs,
            runtimeMax: inputs.runtimeMax.map { RuntimeMinutes.duration(fromMinutes: $0) },
            includeAdult: false,
            withPeople: inputs.personIDs.isEmpty ? nil : inputs.personIDs
        )
    }

    /// Drops a nonsensical runtime the model sometimes invents (e.g. 0).
    static func sanitizedRuntime(_ value: Int?) -> Int? {
        guard let value, value > 0 else {
            return nil
        }
        return value
    }

    /// Drops an out-of-range rating the model sometimes invents (e.g. 0).
    static func sanitizedRating(_ value: Double?) -> Double? {
        guard let value, value > 0, value <= 10 else {
            return nil
        }
        return value
    }

    /// Whether a TMDb crew `job` satisfies a requested role. TMDb records writing
    /// credits under several jobs ("Screenplay", "Story", …) and music under
    /// "Music"/"Composer", so a single role maps to a set of jobs.
    static func jobMatches(_ job: String, role: String) -> Bool {
        let job = job.lowercased()
        let role = role.lowercased()
        if job == role {
            return true
        }
        switch role {
        case "writer":
            return ["screenplay", "story", "author", "novel", "screenstory", "writer"].contains(job)
        case "original music composer":
            return ["music", "composer", "original music composer", "songs"].contains(job)
        default:
            return false
        }
    }

    private func primaryReleaseYear(
        for bounds: (from: Int, to: Int)
    ) -> DiscoverMovieFilter.PrimaryReleaseYearFilter {
        bounds.from == bounds.to
            ? .on(bounds.from)
            : .between(start: bounds.from, end: bounds.to)
    }

}

// MARK: - Date helpers

extension SearchPlanExecutor {

    func yearBounds(for date: SearchPlan.RelativeDate) -> (from: Int, to: Int) {
        let current = currentYear()
        switch date {
        case .thisYear:
            return (current, current)
        case .recent:
            return (current - 1, current)
        case .lastNYears(let years):
            return (current - max(0, years), current)
        case .decade(let start):
            return (start, start + 9)
        case .exactYear(let year):
            return (year, year)
        case .between(let start, let end):
            return (min(start, end), max(start, end))
        }
    }

    private func currentYear() -> Int {
        calendar().component(.year, from: now())
    }

    func startOfYear(_ year: Int) -> Date? {
        calendar().date(from: DateComponents(year: year, month: 1, day: 1))
    }

    func endOfYear(_ year: Int) -> Date? {
        calendar().date(from: DateComponents(year: year, month: 12, day: 31))
    }

    private func year(of date: Date) -> Int {
        calendar().component(.year, from: date)
    }

    private func calendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        // Match the timezone the discover request date formatter uses (the
        // current timezone) so year-boundary Dates round-trip to the intended
        // yyyy-MM-dd string rather than shifting a day in non-UTC zones.
        calendar.timeZone = .current
        return calendar
    }

}

// MARK: - Shaping helpers

extension SearchPlanExecutor {

    func filterByYear<Element>(
        _ items: [Element],
        bounds: (from: Int, to: Int)?,
        date: (Element) -> Date?
    ) -> [Element] {
        guard let bounds else {
            return items
        }

        return items.filter { element in
            guard let elementDate = date(element) else {
                return false
            }

            let elementYear = year(of: elementDate)
            return elementYear >= bounds.from && elementYear <= bounds.to
        }
    }

    func applyExclusions<Element>(
        _ items: [Element],
        plan: SearchPlan,
        name: (Element) -> String,
        into degradations: inout [SearchDegradation]
    ) -> [Element] {
        guard !plan.excludeTitles.isEmpty else {
            return items
        }

        let banned = plan.excludeTitles.map { $0.lowercased() }
        let filtered = items.filter { element in
            let lowered = name(element).lowercased()
            return !banned.contains { lowered.contains($0) }
        }
        if filtered.count != items.count {
            degradations.append(.excludedTermsApplied(plan.excludeTitles))
        }
        return filtered
    }

    func dedupe<Element: Identifiable>(_ items: [Element]) -> [Element] {
        var seen = Set<Element.ID>()
        var result: [Element] = []
        for item in items where seen.insert(item.id).inserted {
            result.append(item)
        }

        return result
    }

    func cap<Element>(_ items: [Element]) -> [Element] {
        Array(items.prefix(resultLimit))
    }

    func person(from cast: CastMember) -> PersonListItem {
        PersonListItem(
            id: cast.id,
            name: cast.name,
            originalName: cast.originalName ?? cast.name,
            knownForDepartment: cast.knownForDepartment,
            gender: cast.gender,
            profilePath: cast.profilePath,
            popularity: cast.popularity,
            isAdultOnly: cast.isAdultOnly
        )
    }

    func person(from crew: CrewMember) -> PersonListItem {
        PersonListItem(
            id: crew.id,
            name: crew.name,
            originalName: crew.originalName ?? crew.name,
            knownForDepartment: crew.knownForDepartment,
            gender: crew.gender,
            profilePath: crew.profilePath,
            popularity: crew.popularity,
            isAdultOnly: crew.isAdultOnly
        )
    }

}

// MARK: - Interpretation

extension SearchPlan {

    /// A short, human-readable restatement of the plan for display.
    var interpretationText: String? {
        title
    }

}
