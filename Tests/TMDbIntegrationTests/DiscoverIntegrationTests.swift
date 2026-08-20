//
//  DiscoverIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .integrationGate,
    .serialized,
    .tags(.discover),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct DiscoverIntegrationTests {

    var discoverService: (any DiscoverService)!

    init() {
        self.discoverService = CredentialHelper.shared.makeClient().discover
    }

    @Test("movies")
    func movies() async throws {
        let movieList = try await discoverService.movies()

        #expect(!movieList.results.isEmpty)
    }

    @Test("movies with filter")
    func moviesWithFilter() async throws {
        let filter = DiscoverMovieFilter(
            genres: [28],
            voteAverageMin: 7.0
        )

        let movieList = try await discoverService.movies(filter: filter)

        #expect(!movieList.results.isEmpty)
    }

    @Test("movies with genres joined by OR")
    func moviesWithGenresJoinedByOr() async throws {
        let filter = DiscoverMovieFilter()
            .withGenres([28, 12], joinedBy: .or)

        let movieList = try await discoverService.movies(filter: filter)

        #expect(!movieList.results.isEmpty)
    }

    @Test("movies with genres joined by AND")
    func moviesWithGenresJoinedByAnd() async throws {
        let filter = DiscoverMovieFilter()
            .withGenres([28, 12], joinedBy: .and)

        let movieList = try await discoverService.movies(filter: filter)

        #expect(!movieList.results.isEmpty)
    }

    @Test("movies AND join is at least as restrictive as OR join")
    func moviesAndJoinIsAtLeastAsRestrictiveAsOrJoin() async throws {
        let orFilter = DiscoverMovieFilter()
            .withGenres([28, 12], joinedBy: .or)
        let andFilter = DiscoverMovieFilter()
            .withGenres([28, 12], joinedBy: .and)

        let orList = try await discoverService.movies(filter: orFilter)
        let andList = try await discoverService.movies(filter: andFilter)

        let orTotal = orList.totalResults
        let andTotal = andList.totalResults

        // Matching ANY of the genres can never yield fewer results than
        // matching ALL of them.
        #expect(orTotal >= andTotal)
    }

    /// The `Date`-granular bounds are accepted and applied by TMDb.
    ///
    /// Deliberately **not** asserting that every returned `releaseDate` falls
    /// inside the window: `release_date.gte`/`.lte` bound *any* release type,
    /// while the `release_date` on a list row is the **primary** release, so a
    /// film with a 2024 festival run and a 2023 primary release legitimately
    /// matches. See `knowledge/tmdb-api-notes.md`, "discover/movie has two
    /// distinct release-date filters".
    ///
    /// The one-day GMT boundary is proved deterministically in
    /// `DayPrecisionDateTests.discoverMoviesRequestSendsGMTCalendarDay`, which
    /// asserts the emitted query item directly. A live result set cannot
    /// distinguish a one-day shift.
    @Test("movies with release date range")
    func moviesWithReleaseDateRange() async throws {
        let rangeStart = Date(timeIntervalSince1970: 1_704_067_200) // 2024-01-01T00:00:00Z
        let rangeEnd = Date(timeIntervalSince1970: 1_735_603_200) // 2024-12-31T00:00:00Z
        let filter = DiscoverMovieFilter(releaseDateMin: rangeStart, releaseDateMax: rangeEnd)

        let movieList = try await discoverService.movies(filter: filter)

        #expect(!movieList.results.isEmpty)

        // The window is applied, not ignored: some result must sit inside it.
        // A wholly-ignored filter would return the unfiltered popular list,
        // which spans decades.
        let releaseDates = movieList.results.compactMap(\.releaseDate)
        #expect(releaseDates.contains { $0 >= rangeStart && $0 <= rangeEnd })
    }

    @Test("movies without watch providers")
    func moviesWithoutWatchProviders() async throws {
        let filter = DiscoverMovieFilter(withoutWatchProviders: [8])

        let movieList = try await discoverService.movies(filter: filter)

        #expect(!movieList.results.isEmpty)
    }

    @Test("TV series")
    func tvSeries() async throws {
        let tvSeriesList = try await discoverService.tvSeries()

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("TV series with filter")
    func tvSeriesWithFilter() async throws {
        let filter = DiscoverTVSeriesFilter(firstAirDateYear: 2024)

        let tvSeriesList = try await discoverService.tvSeries(
            filter: filter
        )

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("TV series including null first air dates")
    func tvSeriesIncludingNullFirstAirDates() async throws {
        let filter = DiscoverTVSeriesFilter(includeNullFirstAirDates: true)

        let tvSeriesList = try await discoverService.tvSeries(filter: filter)

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("TV series without watch providers")
    func tvSeriesWithoutWatchProviders() async throws {
        let filter = DiscoverTVSeriesFilter(withoutWatchProviders: [8])

        let tvSeriesList = try await discoverService.tvSeries(filter: filter)

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("TV series with genres joined by OR")
    func tvSeriesWithGenresJoinedByOr() async throws {
        let filter = DiscoverTVSeriesFilter()
            .withGenres([18, 10765], joinedBy: .or)

        let tvSeriesList = try await discoverService.tvSeries(filter: filter)

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("TV series with genres joined by AND")
    func tvSeriesWithGenresJoinedByAnd() async throws {
        let filter = DiscoverTVSeriesFilter()
            .withGenres([18, 10765], joinedBy: .and)

        let tvSeriesList = try await discoverService.tvSeries(filter: filter)

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("TV series AND join is at least as restrictive as OR join")
    func tvSeriesAndJoinIsAtLeastAsRestrictiveAsOrJoin() async throws {
        let orFilter = DiscoverTVSeriesFilter()
            .withGenres([18, 10765], joinedBy: .or)
        let andFilter = DiscoverTVSeriesFilter()
            .withGenres([18, 10765], joinedBy: .and)

        let orList = try await discoverService.tvSeries(filter: orFilter)
        let andList = try await discoverService.tvSeries(filter: andFilter)

        let orTotal = orList.totalResults
        let andTotal = andList.totalResults

        // Matching ANY of the genres can never yield fewer results than
        // matching ALL of them.
        #expect(orTotal >= andTotal)
    }

}
