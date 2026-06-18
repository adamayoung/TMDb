//
//  ChangesIntegrationTests.swift
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
    .tags(.changes),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct ChangesIntegrationTests {

    var changesService: (any ChangesService)!

    init() {
        self.changesService = CredentialHelper.shared.makeClient().changes
    }

    @Test("movieChanges")
    func movieChanges() async throws {
        let result = try await changesService.movieChanges()

        #expect(result.page >= 1)
        #expect(result.totalPages >= 1)
    }

    @Test("tvSeriesChanges")
    func tvSeriesChanges() async throws {
        let result = try await changesService.tvSeriesChanges()

        #expect(result.page >= 1)
        #expect(result.totalPages >= 1)
    }

    @Test("personChanges")
    func personChanges() async throws {
        let result = try await changesService.personChanges()

        #expect(result.page >= 1)
        #expect(result.totalPages >= 1)
    }

    @Test("movieDetails")
    func movieDetails() async throws {
        let movieID = 550

        let result = try await changesService.movieDetails(
            forMovie: movieID
        )

        _ = result.changes
    }

    @Test("tvSeriesDetails")
    func tvSeriesDetails() async throws {
        let tvSeriesID = 1399

        let result = try await changesService.tvSeriesDetails(
            forTVSeries: tvSeriesID
        )

        _ = result.changes
    }

    @Test("personDetails")
    func personDetails() async throws {
        let personID = 287

        let result = try await changesService.personDetails(
            forPerson: personID
        )

        _ = result.changes
    }

    @Test("tvSeasonDetails")
    func tvSeasonDetails() async throws {
        let seasonID = 3624

        let result = try await changesService.tvSeasonDetails(
            forSeason: seasonID
        )

        _ = result.changes
    }

    @Test("tvEpisodeDetails")
    func tvEpisodeDetails() async throws {
        let episodeID = 62085

        let result = try await changesService.tvEpisodeDetails(
            forEpisode: episodeID
        )

        _ = result.changes
    }

    @Test("allMovieChanges paginates across pages")
    func allMovieChanges() async throws {
        var items: [ChangedID] = []
        for try await item in changesService.allMovieChanges().prefix(25) {
            items.append(item)
        }

        #expect(items.isEmpty == false)
    }

    @Test("allMovieChangesPages yields pages")
    func allMovieChangesPages() async throws {
        var pages: [PageableListResult<ChangedID>] = []
        for try await page in changesService.allMovieChangesPages().prefix(1) {
            pages.append(page)
        }

        let firstPage = try #require(pages.first)
        #expect(firstPage.page >= 1)
        #expect(firstPage.results.isEmpty == false)
    }

}
