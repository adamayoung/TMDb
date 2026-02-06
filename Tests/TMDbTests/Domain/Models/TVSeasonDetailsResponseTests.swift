//
//  TVSeasonDetailsResponseTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVSeasonDetailsResponseTests {

    @Test("JSON decoding of TVSeasonDetailsResponse", .tags(.decoding))
    func decodeTVSeasonDetailsResponse() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeasonDetailsResponse.self,
            fromResource: "tv-season-details-append-response"
        )

        #expect(result.season.id == 3624)
        #expect(result.season.name == "Season 1")
        #expect(result.season.seasonNumber == 1)

        let credits = try #require(result.credits)
        #expect(credits.id == 3624)
        #expect(!credits.cast.isEmpty)
        #expect(credits.cast[0].id == 1_223_786)
        #expect(credits.cast[0].name == "Emilia Clarke")
        #expect(credits.cast[0].character == "Daenerys Targaryen")
        #expect(!credits.crew.isEmpty)
        #expect(credits.crew[0].id == 44797)
        #expect(credits.crew[0].name == "Tim Van Patten")
        #expect(credits.crew[0].job == "Director")
    }

    @Test(
        "JSON decoding of TVSeasonDetailsResponse without appended data",
        .tags(.decoding)
    )
    func decodeTVSeasonDetailsResponseWithoutAppendedData() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeasonDetailsResponse.self,
            fromResource: "tv-season"
        )

        #expect(result.season.id == 3624)
        #expect(result.season.name == "Season 1")
        #expect(result.season.seasonNumber == 1)
        #expect(result.credits == nil)
        #expect(result.aggregateCredits == nil)
        #expect(result.images == nil)
        #expect(result.videos == nil)
        #expect(result.translations == nil)
        #expect(result.watchProviders == nil)
        #expect(result.externalIDs == nil)
    }

}
