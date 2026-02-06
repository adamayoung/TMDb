//
//  MovieDetailsResponseTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct MovieDetailsResponseTests {

    @Test("JSON decoding of MovieDetailsResponse", .tags(.decoding))
    func decodeMovieDetailsResponse() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieDetailsResponse.self,
            fromResource: "movie-details-append-response"
        )

        #expect(result.movie.id == 550)
        #expect(result.movie.title == "Fight Club")

        let credits = try #require(result.credits)
        #expect(credits.id == 550)
        #expect(!credits.cast.isEmpty)
        #expect(credits.cast[0].id == 819)
        #expect(credits.cast[0].name == "Edward Norton")
        #expect(credits.cast[0].character == "The Narrator")
        #expect(!credits.crew.isEmpty)
        #expect(credits.crew[0].id == 7467)
        #expect(credits.crew[0].name == "David Fincher")
        #expect(credits.crew[0].job == "Director")

        let images = try #require(result.images)
        #expect(images.id == 550)
        #expect(!images.backdrops.isEmpty)
        #expect(!images.posters.isEmpty)
        #expect(images.logos.isEmpty)

        let keywords = try #require(result.keywords)
        #expect(keywords.count == 2)
        #expect(keywords[0].id == 851)
        #expect(keywords[0].name == "dual identity")
        #expect(keywords[1].id == 818)

        let externalIDs = try #require(result.externalIDs)
        #expect(externalIDs.id == 550)
        #expect(externalIDs.imdb != nil)
        #expect(externalIDs.imdb?.id == "tt0137523")
        #expect(externalIDs.wikiData != nil)
        #expect(externalIDs.facebook != nil)
    }

    @Test(
        "JSON decoding of MovieDetailsResponse without appended data",
        .tags(.decoding)
    )
    func decodeMovieDetailsResponseWithoutAppendedData() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieDetailsResponse.self,
            fromResource: "movie"
        )

        #expect(result.movie.id == 550)
        #expect(result.movie.title == "Fight Club")
        #expect(result.credits == nil)
        #expect(result.images == nil)
        #expect(result.videos == nil)
        #expect(result.reviews == nil)
        #expect(result.recommendations == nil)
        #expect(result.similar == nil)
        #expect(result.releaseDates == nil)
        #expect(result.alternativeTitles == nil)
        #expect(result.translations == nil)
        #expect(result.keywords == nil)
        #expect(result.watchProviders == nil)
        #expect(result.externalIDs == nil)
        #expect(result.lists == nil)
        #expect(result.changes == nil)
    }

}
