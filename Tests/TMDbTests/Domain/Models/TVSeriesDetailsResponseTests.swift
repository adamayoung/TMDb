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

    @Test("JSON decoding of TVSeriesDetailsResponse", .tags(.decoding))
    func decodeTVSeriesDetailsResponse() throws {
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
        #expect(credits.cast[0].character == "Tyrion Lannister")
        #expect(!credits.crew.isEmpty)
        #expect(credits.crew[0].id == 9813)
        #expect(credits.crew[0].name == "David Benioff")
        #expect(credits.crew[0].job == "Executive Producer")

        let images = try #require(result.images)
        #expect(images.id == 1399)
        #expect(!images.backdrops.isEmpty)
        #expect(!images.posters.isEmpty)
        #expect(images.logos.isEmpty)
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
