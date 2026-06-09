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
