//
//  TVSeriesDetailsResponseTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVSeriesDetailsResponseTests {

    @Test(
        "JSON decoding of TVSeriesDetailsResponse with credits and images",
        .tags(.decoding)
    )
    func decodeTVSeriesDetailsResponseCreditsAndImages() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesDetailsResponse.self,
            fromResource: "tv-series-details-append-response"
        )

        #expect(result.tvSeries.id == 1399)
        #expect(result.tvSeries.name == "Game of Thrones")

        let credits = try #require(result.credits)
        #expect(credits.id == 1399)
        #expect(!credits.cast.isEmpty)
        #expect(credits.cast[0].id == 22970)
        #expect(credits.cast[0].name == "Peter Dinklage")
        #expect(!credits.crew.isEmpty)
        #expect(credits.crew[0].id == 9813)

        let aggregateCredits = try #require(result.aggregateCredits)
        #expect(aggregateCredits.id == 1399)
        #expect(!aggregateCredits.cast.isEmpty)
        #expect(!aggregateCredits.crew.isEmpty)

        let images = try #require(result.images)
        #expect(images.id == 1399)
        #expect(!images.backdrops.isEmpty)
        #expect(!images.posters.isEmpty)

        let externalIDs = try #require(result.externalIDs)
        #expect(externalIDs.id == 1399)
        #expect(externalIDs.imdb != nil)
    }

    @Test(
        "JSON decoding of TVSeriesDetailsResponse with all appended data",
        .tags(.decoding)
    )
    func decodeTVSeriesDetailsResponseAllAppendedData() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesDetailsResponse.self,
            fromResource: "tv-series-details-append-response"
        )

        let videos = try #require(result.videos)
        #expect(videos.id == 1399)
        #expect(!videos.results.isEmpty)

        let reviews = try #require(result.reviews)
        #expect(!reviews.results.isEmpty)
        #expect(reviews.results[0].id == "review123")

        let recommendations = try #require(result.recommendations)
        #expect(!recommendations.results.isEmpty)
        #expect(recommendations.results[0].id == 1396)

        let similar = try #require(result.similar)
        #expect(!similar.results.isEmpty)
        #expect(similar.results[0].id == 66732)

        let contentRatings = try #require(result.contentRatings)
        #expect(!contentRatings.isEmpty)
        #expect(contentRatings[0].countryCode == "US")
        #expect(contentRatings[0].rating == "TV-MA")

        let altTitles = try #require(result.alternativeTitles)
        #expect(!altTitles.isEmpty)
        #expect(altTitles[0].countryCode == "DE")

        let translations = try #require(result.translations)
        #expect(!translations.isEmpty)
        #expect(translations[0].countryCode == "DE")

        let keywords = try #require(result.keywords)
        #expect(!keywords.isEmpty)
        #expect(keywords[0].id == 6091)

        let watchProviders = try #require(result.watchProviders)
        let usProvider = try #require(watchProviders["US"])
        let flatRate = try #require(usProvider.flatRate)
        #expect(flatRate[0].id == 384)

        let screenedTheatrically = try #require(
            result.screenedTheatrically
        )
        #expect(!screenedTheatrically.isEmpty)
        #expect(screenedTheatrically[0].episodeNumber == 1)

        let episodeGroups = try #require(result.episodeGroups)
        #expect(!episodeGroups.isEmpty)
        #expect(episodeGroups[0].name == "Aired Order")

        let lists = try #require(result.lists)
        #expect(!lists.results.isEmpty)

        let changes = try #require(result.changes)
        #expect(!changes.changes.isEmpty)
        #expect(changes.changes[0].key == "overview")
    }

    @Test(
        "JSON decoding of TVSeriesDetailsResponse without appended data",
        .tags(.decoding)
    )
    func decodeTVSeriesDetailsResponseWithoutAppendedData() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesDetailsResponse.self,
            fromResource: "tv-series"
        )

        #expect(result.tvSeries.id == 1399)
        #expect(result.tvSeries.name == "Game of Thrones")
        #expect(result.credits == nil)
        #expect(result.aggregateCredits == nil)
        #expect(result.images == nil)
        #expect(result.videos == nil)
        #expect(result.reviews == nil)
        #expect(result.recommendations == nil)
        #expect(result.similar == nil)
        #expect(result.contentRatings == nil)
        #expect(result.alternativeTitles == nil)
        #expect(result.translations == nil)
        #expect(result.keywords == nil)
        #expect(result.watchProviders == nil)
        #expect(result.externalIDs == nil)
        #expect(result.screenedTheatrically == nil)
        #expect(result.episodeGroups == nil)
        #expect(result.lists == nil)
        #expect(result.changes == nil)
    }

}
