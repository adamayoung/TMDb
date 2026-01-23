//
//  TVSeriesServiceTests.swift
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
struct TVSeriesServiceTests {

    var tvSeriesService: (any TVSeriesService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.tvSeriesService = TMDbClient(apiKey: apiKey).tvSeries
    }

    @Test("details")
    func details() async throws {
        let tvSeriesID = 84958

        let tvSeries = try await tvSeriesService.details(forTVSeries: tvSeriesID)

        #expect(tvSeries.id == tvSeriesID)
        #expect(tvSeries.name == "Loki")
    }

    @Test("credits")
    func credits() async throws {
        let tvSeriesID = 4604

        let credits = try await tvSeriesService.credits(forTVSeries: tvSeriesID)

        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
    }

    @Test("aggregateCredits")
    func aggregateCredits() async throws {
        let tvSeriesID = 4604

        let credits = try await tvSeriesService.aggregateCredits(forTVSeries: tvSeriesID)

        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
    }

    @Test("reviews")
    func reviews() async throws {
        let tvSeriesID = 76479

        let reviewList = try await tvSeriesService.reviews(forTVSeries: tvSeriesID)

        #expect(!reviewList.results.isEmpty)
    }

    @Test("images")
    func images() async throws {
        let tvSeriesID = 76479

        let imageCollection = try await tvSeriesService.images(forTVSeries: tvSeriesID)

        #expect(imageCollection.id == tvSeriesID)
        #expect(!imageCollection.backdrops.isEmpty)
        #expect(!imageCollection.logos.isEmpty)
        #expect(!imageCollection.posters.isEmpty)
    }

    @Test("videos")
    func videos() async throws {
        let tvSeriesID = 76479

        let videoCollection = try await tvSeriesService.videos(forTVSeries: tvSeriesID)

        #expect(videoCollection.id == tvSeriesID)
        #expect(!videoCollection.results.isEmpty)
    }

    @Test("recommendations")
    func recommendations() async throws {
        let tvSeriesID = 549

        let tvSeriesList = try await tvSeriesService.recommendations(forTVSeries: tvSeriesID)

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("similar")
    func similar() async throws {
        let tvSeriesID = 76479

        let tvSeriesList = try await tvSeriesService.similar(toTVSeries: tvSeriesID)

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("popular")
    func popular() async throws {
        let tvSeriesList = try await tvSeriesService.popular()

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("airingToday")
    func airingToday() async throws {
        let tvSeriesList = try await tvSeriesService.airingToday()

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("onTheAir")
    func onTheAir() async throws {
        let tvSeriesList = try await tvSeriesService.onTheAir()

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("topRated")
    func topRated() async throws {
        let tvSeriesList = try await tvSeriesService.topRated()

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("externalLinks")
    func externalLinks() async throws {
        let tvSeriesID = 86423

        let linksCollection = try await tvSeriesService.externalLinks(forTVSeries: tvSeriesID)

        #expect(linksCollection.id == tvSeriesID)
        #expect(linksCollection.imdb != nil)
        #expect(linksCollection.wikiData != nil)
        #expect(linksCollection.facebook != nil)
        #expect(linksCollection.instagram != nil)
        #expect(linksCollection.twitter != nil)
    }

    @Test("contentRatings")
    func contentRatings() async throws {
        let tvSeriesID = 8592

        let allContentRatings = try await tvSeriesService.contentRatings(forTVSeries: tvSeriesID)

        #expect(!allContentRatings.isEmpty)

        let usRating = allContentRatings.first { $0.countryCode == "US" }
        let unwrappedUSRating = try #require(usRating)

        #expect(unwrappedUSRating.rating == "TV-14")
        #expect(unwrappedUSRating.countryCode == "US")
    }

    @Test("details includes lastEpisodeToAir and nextEpisodeToAir for airing series")
    func detailsIncludesEpisodeAirDatesForAiringSeries() async throws {
        // The Pitt - currently airing series
        let tvSeriesID = 250_307

        let tvSeries = try await tvSeriesService.details(forTVSeries: tvSeriesID)

        #expect(tvSeries.id == tvSeriesID)

        // lastEpisodeToAir should exist for currently airing shows
        if let lastEpisode = tvSeries.lastEpisodeToAir {
            #expect(lastEpisode.id > 0)
            #expect(!lastEpisode.name.isEmpty)
            #expect(lastEpisode.episodeNumber > 0)
            #expect(lastEpisode.seasonNumber > 0)
            #expect(lastEpisode.showID == tvSeriesID)
        }

        // nextEpisodeToAir may exist for currently airing shows
        if let nextEpisode = tvSeries.nextEpisodeToAir {
            #expect(nextEpisode.id > 0)
            #expect(!nextEpisode.name.isEmpty)
            #expect(nextEpisode.episodeNumber > 0)
            #expect(nextEpisode.seasonNumber > 0)
            #expect(nextEpisode.showID == tvSeriesID)
        }
    }

    @Test("details for ended series has lastEpisodeToAir but no nextEpisodeToAir")
    func detailsForEndedSeries() async throws {
        // Breaking Bad - ended series
        let tvSeriesID = 1396

        let tvSeries = try await tvSeriesService.details(forTVSeries: tvSeriesID)

        #expect(tvSeries.id == tvSeriesID)
        #expect(tvSeries.lastEpisodeToAir != nil)

        // Verify lastEpisodeToAir details
        if let lastEpisode = tvSeries.lastEpisodeToAir {
            #expect(lastEpisode.id > 0)
            #expect(lastEpisode.name == "Felina")
            #expect(lastEpisode.episodeNumber == 16)
            #expect(lastEpisode.seasonNumber == 5)
            #expect(lastEpisode.showID == tvSeriesID)
            #expect(lastEpisode.episodeType == "finale")
        }

        // nextEpisodeToAir should be nil for ended series
        #expect(tvSeries.nextEpisodeToAir == nil)
    }
}
