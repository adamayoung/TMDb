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

    @Test("JSON decoding of PersonDetailsResponse", .tags(.decoding))
    func decodePersonDetailsResponse() throws {
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
        #expect(movieCredits.crew[0].title == "The Departed")
        #expect(movieCredits.crew[0].job == "Producer")

        let images = try #require(result.images)
        #expect(images.id == 287)
        #expect(!images.profiles.isEmpty)
        #expect(images.profiles[0].width == 1200)
        #expect(images.profiles[0].height == 1800)
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
