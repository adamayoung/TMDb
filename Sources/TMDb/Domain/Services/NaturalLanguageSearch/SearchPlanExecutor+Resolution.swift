//
//  SearchPlanExecutor+Resolution.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// A search result that carries a popularity score, used to rank title matches.
protocol PopularityRanked {
    var popularity: Double? { get }
}

extension MovieListItem: PopularityRanked {}
extension TVSeriesListItem: PopularityRanked {}

// MARK: - Title resolution

extension SearchPlanExecutor {

    /// The resolved identity of a title-bearing query.
    enum ResolvedShow {
        case movie(Movie.ID)
        case tvSeries(TVSeries.ID)
    }

    /// Answers a "by person" TV query from the person's TV credits, since TMDb's
    /// discover/tv cannot filter by person. Credits arrive ranked by relevance
    /// (episode count) from the data source, so that order is preserved.
    func executeByPersonTVSeries(
        _ plan: SearchPlan,
        degradations: inout [SearchDegradation]
    ) async throws -> NaturalLanguageSearchResult {
        let personIDs = try await resolvePeople(plan.people, into: &degradations)
        guard !personIDs.isEmpty else {
            return try await executeUnderspecified(plan, degradations: &degradations)
        }

        var series: [TVSeriesListItem] = []
        for id in personIDs {
            series += try await dataSource.tvSeriesCredits(forPerson: id)
        }

        let bounds = plan.date.map(yearBounds(for:))
        series = filterByYear(series, bounds: bounds, date: { $0.firstAirDate })
        series = applyExclusions(series, plan: plan, name: { $0.name }, into: &degradations)
        return NaturalLanguageSearchResult(
            interpretation: plan.interpretationText,
            tvSeries: cap(dedupe(series)),
            degradations: degradations
        )
    }

    func credits(forTitle plan: SearchPlan) async throws -> ShowCredits? {
        guard let title = plan.title,
              let show = try await resolveShow(title: title, mediaType: plan.mediaType)
        else {
            return nil
        }

        switch show {
        case .movie(let id): return try await dataSource.movieCredits(forMovie: id)
        case .tvSeries(let id): return try await dataSource.tvSeriesCredits(forTVSeries: id)
        }
    }

    /// Resolves a title to a movie or TV series. When the media type is known the
    /// matching endpoint is used; when it is ambiguous (e.g. "cast of Breaking
    /// Bad") the best movie and best TV candidate are compared, preferring an
    /// exact title match and then popularity — so "Breaking Bad" resolves to the
    /// series rather than the "El Camino" movie. The top few results are scanned
    /// (not just the first) so an exact match that isn't the top hit still wins
    /// (e.g. "Jaws", where "Cruel Jaws" ranks first).
    func resolveShow(title: String, mediaType: SearchPlan.MediaType?) async throws -> ResolvedShow? {
        if mediaType == .tv {
            let best = try await Self.best(dataSource.searchTVSeries(query: title), query: title, name: \.name)
            return best.map { .tvSeries($0.id) }
        }
        if mediaType == .movie {
            let best = try await Self.best(dataSource.searchMovies(query: title), query: title, name: \.title)
            return best.map { .movie($0.id) }
        }

        async let movieResults = dataSource.searchMovies(query: title)
        async let tvResults = dataSource.searchTVSeries(query: title)
        let movie = try await Self.best(movieResults, query: title, name: \.title)
        let tv = try await Self.best(tvResults, query: title, name: \.name)

        switch (movie, tv) {
        case (let movie?, let tv?):
            // Ties (equal title match and popularity) resolve in favour of the movie.
            return tv.score > movie.score ? .tvSeries(tv.id) : .movie(movie.id)
        case (let movie?, nil):
            return .movie(movie.id)
        case (nil, let tv?):
            return .tvSeries(tv.id)
        case (nil, nil):
            return nil
        }
    }

    /// The best-scoring candidate among the top results: an exact (case-insensitive)
    /// title match dominates, with popularity as the tie-breaker. Only the top 8
    /// results are scanned — an exact match buried past position 8 by TMDb's own
    /// ordering (possible for titles with many near-homonyms) would be missed.
    private static func best<Item: Identifiable & PopularityRanked>(
        _ items: [Item],
        query: String,
        name: (Item) -> String
    ) -> (id: Item.ID, score: Double)? {
        items.prefix(8)
            .map { (id: $0.id, score: matchScore(title: name($0), query: query, popularity: $0.popularity)) }
            .max { $0.score < $1.score }
    }

    /// Scores a candidate: an exact (case-insensitive) title match dominates, with
    /// popularity as the tie-breaker.
    static func matchScore(title: String, query: String, popularity: Double?) -> Double {
        let exact = title.caseInsensitiveCompare(query) == .orderedSame ? 1_000_000.0 : 0
        return exact + (popularity ?? 0)
    }

}
