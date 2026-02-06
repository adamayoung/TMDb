//
//  PersonDetailsResponseTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct PersonDetailsResponseTests {

    @Test(
        "JSON decoding of PersonDetailsResponse with movie credits and images",
        .tags(.decoding)
    )
    func decodePersonDetailsResponseCreditsAndImages() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            PersonDetailsResponse.self,
            fromResource: "person-details-append-response"
        )

        #expect(result.person.id == 287)
        #expect(result.person.name == "Brad Pitt")

        let movieCredits = try #require(result.movieCredits)
        #expect(movieCredits.id == 287)
        #expect(!movieCredits.cast.isEmpty)
        #expect(movieCredits.cast[0].id == 550)
        #expect(movieCredits.cast[0].title == "Fight Club")
        #expect(movieCredits.cast[0].character == "Tyler Durden")
        #expect(!movieCredits.crew.isEmpty)
        #expect(movieCredits.crew[0].id == 45612)
        #expect(movieCredits.crew[0].job == "Producer")

        let images = try #require(result.images)
        #expect(images.id == 287)
        #expect(!images.profiles.isEmpty)
    }

    @Test(
        "JSON decoding of PersonDetailsResponse with all appended data",
        .tags(.decoding)
    )
    func decodePersonDetailsResponseAllAppendedData() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            PersonDetailsResponse.self,
            fromResource: "person-details-append-response"
        )

        let tvCredits = try #require(result.tvCredits)
        #expect(tvCredits.id == 287)
        #expect(!tvCredits.cast.isEmpty)
        #expect(tvCredits.cast[0].id == 12345)
        #expect(!tvCredits.crew.isEmpty)
        #expect(tvCredits.crew[0].id == 12346)

        let combinedCredits = try #require(result.combinedCredits)
        #expect(combinedCredits.id == 287)
        #expect(!combinedCredits.cast.isEmpty)
        #expect(!combinedCredits.crew.isEmpty)

        let taggedImages = try #require(result.taggedImages)
        #expect(!taggedImages.results.isEmpty)
        #expect(taggedImages.results[0].id == "tagged1")

        let translations = try #require(result.translations)
        #expect(!translations.isEmpty)
        #expect(translations[0].countryCode == "DE")

        let externalIDs = try #require(result.externalIDs)
        #expect(externalIDs.id == 287)
        #expect(externalIDs.imdb != nil)
        #expect(externalIDs.tikTok != nil)
        #expect(externalIDs.facebook != nil)

        let changes = try #require(result.changes)
        #expect(!changes.changes.isEmpty)
        #expect(changes.changes[0].key == "biography")
    }

    @Test(
        "JSON decoding of PersonDetailsResponse without appended data",
        .tags(.decoding)
    )
    func decodePersonDetailsResponseWithoutAppendedData() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            PersonDetailsResponse.self,
            fromResource: "person"
        )

        #expect(result.person.id == 287)
        #expect(result.person.name == "Brad Pitt")
        #expect(result.movieCredits == nil)
        #expect(result.tvCredits == nil)
        #expect(result.combinedCredits == nil)
        #expect(result.images == nil)
        #expect(result.taggedImages == nil)
        #expect(result.translations == nil)
        #expect(result.externalIDs == nil)
        #expect(result.changes == nil)
    }

}
