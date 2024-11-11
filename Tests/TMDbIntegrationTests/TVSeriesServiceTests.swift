//
//  TVSeriesServiceTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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

    @Test("externalLinks")
    func externalLinks() async throws {
        let tvSeriesID = 86423

        let linksCollection = try await tvSeriesService.externalLinks(forTVSeries: tvSeriesID)

        #expect(linksCollection.id == tvSeriesID)
        #expect(linksCollection.imdb != nil)
        #expect(linksCollection.wikiData == nil)
        #expect(linksCollection.facebook != nil)
        #expect(linksCollection.instagram != nil)
        #expect(linksCollection.twitter != nil)
    }

    @Test("contentRatings")
    func contentRatings() async throws {
        let tvSeriesID = 8592

        let contentRatings = try #require(
            await tvSeriesService.contentRatings(forTVSeries: tvSeriesID, country: "US"))

        #expect(contentRatings.rating == "TV-14")
        #expect(contentRatings.countryCode == "US")
    }
}
