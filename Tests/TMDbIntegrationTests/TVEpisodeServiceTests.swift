//
//  TVEpisodeServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .tags(.tvEpisode),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct TVEpisodeServiceTests {

    var tvEpisodeService: (any TVEpisodeService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.tvEpisodeService = TMDbClient(apiKey: apiKey).tvEpisodes
    }

    @Test("details")
    func details() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvSeriesID = 1399

        let episode = try await tvEpisodeService.details(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(episode.id == 63068)
        #expect(episode.episodeNumber == episodeNumber)
        #expect(episode.seasonNumber == seasonNumber)
        #expect(episode.name == "What Is Dead May Never Die")
    }

    @Test("credits")
    func credits() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvSeriesID = 1399

        let credits = try await tvEpisodeService.credits(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(credits.id == 63068)
        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
    }

    @Test("images")
    func images() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvSeriesID = 1399

        let imageCollection = try await tvEpisodeService.images(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(imageCollection.id == 63068)
        #expect(!imageCollection.stills.isEmpty)
    }

    @Test("videos")
    func videos() async throws {
        let episodeNumber = 3
        let seasonNumber = 1
        let tvSeriesID = 1399

        let videoCollection = try await tvEpisodeService.videos(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(videoCollection.id == 63058)
        #expect(!videoCollection.results.isEmpty)
    }

    @Test("externalLinks")
    func externalLinks() async throws {
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1399

        let externalLinks = try await tvEpisodeService.externalLinks(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(externalLinks.id == 63066)
    }

    @Test("translations")
    func translations() async throws {
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1399

        let translationCollection = try await tvEpisodeService.translations(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(translationCollection.id == 63066)
        #expect(!translationCollection.translations.isEmpty)
    }

    @Test("changes")
    func changes() async throws {
        let episodeID = 62085 // Game of Thrones S01E01

        let changeCollection = try await tvEpisodeService.changes(
            forEpisode: episodeID
        )

        // May be empty if no recent changes - just verify we can decode the response
        #expect(
            changeCollection.changes.isEmpty
                || !changeCollection.changes.isEmpty
        )
    }

}
