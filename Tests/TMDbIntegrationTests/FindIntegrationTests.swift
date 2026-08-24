//
//  FindIntegrationTests.swift
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
    .tags(.find),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct FindIntegrationTests {

    var findService: (any FindService)!

    init() {
        self.findService = CredentialHelper.shared.makeClient().find
    }

    @Test("find movie by IMDb ID")
    func findMovieByIMDbID() async throws {
        // The Shawshank Redemption
        let externalID = "tt0111161"

        let results = try await findService.find(externalID: externalID, externalSource: .imdbID)

        #expect(!results.movieResults.isEmpty)
        #expect(results.movieResults.first?.id == 278)
        #expect(results.movieResults.first?.title == "The Shawshank Redemption")
    }

    @Test("find TV series by TVDB ID")
    func findTVSeriesByTVDBID() async throws {
        // Breaking Bad
        let externalID = "81189"

        let results = try await findService.find(externalID: externalID, externalSource: .tvdbID)

        #expect(!results.tvResults.isEmpty)
        #expect(results.tvResults.first?.id == 1396)
        #expect(results.tvResults.first?.name == "Breaking Bad")
    }

    ///
    /// `tv_season_results` was empty in every captured fixture until now, so it
    /// had never decoded a real row. It matters because `/find` is one of only
    /// two endpoints that send `show_id` on a season — the other being
    /// `/person/{id}/tagged_images` — so this is the live check behind
    /// `TVSeason.showID` on this surface.
    ///
    @Test("find TV season by TVDB ID")
    func findTVSeasonByTVDBID() async throws {
        // True Detective season 1
        let externalID = "522572"

        let results = try await findService.find(externalID: externalID, externalSource: .tvdbID)

        let tvSeason = try #require(results.tvSeasonResults.first)
        #expect(tvSeason.id == 59780)
        #expect(tvSeason.seasonNumber == 1)
        #expect(tvSeason.showID == 46648)
    }

    @Test("find returns empty results for non-existent ID")
    func findReturnsEmptyResultsForNonExistentID() async throws {
        let externalID = "tt0000000000"

        let results = try await findService.find(externalID: externalID, externalSource: .imdbID)

        #expect(results.movieResults.isEmpty)
        #expect(results.tvResults.isEmpty)
        #expect(results.personResults.isEmpty)
    }

    @Test("find with empty external ID throws bad request")
    func findWithEmptyExternalIDThrowsBadRequest() async throws {
        await #expect(throws: TMDbError.self) {
            _ = try await findService.find(externalID: "", externalSource: .imdbID)
        }
    }

}
