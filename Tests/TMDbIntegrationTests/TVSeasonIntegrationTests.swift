//
//  TVSeasonIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .tags(.tvSeason),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct TVSeasonIntegrationTests {

    var tvSeasonService: (any TVSeasonService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.tvSeasonService = TMDbClient(apiKey: apiKey).tvSeasons
    }

    @Test("details")
    func testDetails() async throws {
        let seasonNumber = 2
        let tvSeriesID = 1399

        let season = try await tvSeasonService.details(
            forSeason: seasonNumber, inTVSeries: tvSeriesID
        )

        #expect(season.seasonNumber == seasonNumber)
        #expect(!(season.episodes ?? []).isEmpty)
    }

    @Test("aggregateCredits")
    func aggregateCredits() async throws {
        let seasonNumber = 2
        let tvSeriesID = 1399

        let credits = try await tvSeasonService.aggregateCredits(
            forSeason: seasonNumber, inTVSeries: tvSeriesID
        )

        #expect(credits.id == 3625)
        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
    }

    @Test("credits")
    func credits() async throws {
        let seasonNumber = 2
        let tvSeriesID = 1399

        let credits = try await tvSeasonService.credits(
            forSeason: seasonNumber, inTVSeries: tvSeriesID
        )

        #expect(credits.id == 3625)
        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
    }

    @Test("images")
    func images() async throws {
        let seasonNumber = 1
        let tvSeriesID = 1399

        let imagesCollection = try await tvSeasonService.images(
            forSeason: seasonNumber, inTVSeries: tvSeriesID
        )

        #expect(!imagesCollection.posters.isEmpty)
    }

    @Test("videos")
    func videos() async throws {
        let seasonNumber = 1
        let tvSeriesID = 1399

        let videoCollection = try await tvSeasonService.videos(
            forSeason: seasonNumber, inTVSeries: tvSeriesID
        )

        #expect(!videoCollection.results.isEmpty)
    }

    @Test("externalLinks")
    func externalLinks() async throws {
        let seasonNumber = 2
        let tvSeriesID = 1399

        let externalLinks = try await tvSeasonService.externalLinks(
            forSeason: seasonNumber, inTVSeries: tvSeriesID
        )

        #expect(externalLinks.id == 3625)
    }

    @Test("translations")
    func translations() async throws {
        let seasonNumber = 2
        let tvSeriesID = 1399

        let translationCollection = try await tvSeasonService.translations(
            forSeason: seasonNumber, inTVSeries: tvSeriesID
        )

        #expect(translationCollection.id == 3625)
        #expect(!translationCollection.translations.isEmpty)
    }

    @Test("watchProviders")
    func watchProviders() async throws {
        let seasonNumber = 2
        let tvSeriesID = 1399

        let watchProviders = try await tvSeasonService.watchProviders(
            forSeason: seasonNumber, inTVSeries: tvSeriesID
        )

        #expect(!watchProviders.isEmpty)
    }

}
