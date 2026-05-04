//
//  ReviewTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ReviewTests {

    @Test("JSON decoding of Review", .tags(.decoding))
    func decodeReturnsReview() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(Review.self, fromResource: "review")

        #expect(result.id == review.id)
        #expect(result.author == review.author)
        #expect(result.content == review.content)
        #expect(result.languageCode == review.languageCode)
        #expect(result.mediaID == review.mediaID)
        #expect(result.mediaTitle == review.mediaTitle)
        #expect(result.mediaType == review.mediaType)

        let authorDetails = try #require(result.authorDetails)
        #expect(authorDetails.name == review.authorDetails?.name)
        #expect(authorDetails.username == review.authorDetails?.username)
        #expect(authorDetails.avatarPath == review.authorDetails?.avatarPath)
        #expect(authorDetails.rating == review.authorDetails?.rating)

        #expect(result.url == review.url)

        let createdAt = try #require(result.createdAt)
        let createdAtComponents = try Calendar(identifier: .gregorian)
            .dateComponents(
                in: #require(TimeZone(identifier: "UTC")),
                from: createdAt
            )
        #expect(createdAtComponents.year == 2014)
        #expect(createdAtComponents.month == 12)
        #expect(createdAtComponents.day == 10)

        let updatedAt = try #require(result.updatedAt)
        let updatedAtComponents = try Calendar(identifier: .gregorian)
            .dateComponents(
                in: #require(TimeZone(identifier: "UTC")),
                from: updatedAt
            )
        #expect(updatedAtComponents.year == 2021)
        #expect(updatedAtComponents.month == 6)
        #expect(updatedAtComponents.day == 23)
    }

    @Test(
        "JSON decoding of Review with non-fractional second dates",
        .tags(.decoding)
    )
    func decodeWithNonFractionalSecondDatesReturnsReview() throws {
        let json = """
        {
            "id": "abc123",
            "author": "Test Author",
            "content": "Test content",
            "created_at": "2014-12-10T22:00:59Z",
            "updated_at": "2021-06-23T15:57:31Z"
        }
        """
        let data = try #require(json.data(using: .utf8))
        let result = try JSONDecoder.theMovieDatabase
            .decode(Review.self, from: data)

        let createdAt = try #require(result.createdAt)
        let createdAtComponents = try Calendar(identifier: .gregorian)
            .dateComponents(
                in: #require(TimeZone(identifier: "UTC")),
                from: createdAt
            )
        #expect(createdAtComponents.year == 2014)
        #expect(createdAtComponents.month == 12)
        #expect(createdAtComponents.day == 10)
        #expect(createdAtComponents.hour == 22)
        #expect(createdAtComponents.minute == 0)
        #expect(createdAtComponents.second == 59)

        let updatedAt = try #require(result.updatedAt)
        let updatedAtComponents = try Calendar(identifier: .gregorian)
            .dateComponents(
                in: #require(TimeZone(identifier: "UTC")),
                from: updatedAt
            )
        #expect(updatedAtComponents.year == 2021)
        #expect(updatedAtComponents.month == 6)
        #expect(updatedAtComponents.day == 23)
        #expect(updatedAtComponents.hour == 15)
        #expect(updatedAtComponents.minute == 57)
        #expect(updatedAtComponents.second == 31)
    }

    @Test(
        "JSON decoding of Review without optional data",
        .tags(.decoding)
    )
    func decodeWithoutOptionalDataReturnsReview() throws {
        let json = """
        {
            "id": "abc123",
            "author": "Test Author",
            "content": "Test content"
        }
        """
        let data = try #require(json.data(using: .utf8))
        let result = try JSONDecoder.theMovieDatabase
            .decode(Review.self, from: data)

        #expect(result.id == "abc123")
        #expect(result.author == "Test Author")
        #expect(result.content == "Test content")
        #expect(result.languageCode == nil)
        #expect(result.mediaID == nil)
        #expect(result.mediaTitle == nil)
        #expect(result.mediaType == nil)
        #expect(result.authorDetails == nil)
        #expect(result.url == nil)
        #expect(result.createdAt == nil)
        #expect(result.updatedAt == nil)
    }

    private let review = Review(
        id: "5488c29bc3a3686f4a00004a",
        author: "Travis Bell",
        content:
        // swiftlint:disable:next line_length
        "Like most of the reviews here, I agree that Guardians of the Galaxy was an absolute hoot. Guardians never takes itself too seriously which makes this movie a whole lot of fun. The cast was perfectly chosen and even though two of the main five were CG, knowing who voiced and acted alongside them completely filled out these characters. Guardians of the Galaxy is one of those rare complete audience pleasers. Good fun for everyone!",
        languageCode: "en",
        mediaID: 118_340,
        mediaTitle: "Guardians of the Galaxy",
        mediaType: "movie",
        authorDetails: ReviewAuthorDetails(
            name: "Travis Bell",
            username: "travisbell",
            avatarPath: URL(string: "/utBEztLMnid37MJOhm4Nfg0Frv6.jpg"),
            rating: 8.0
        ),
        url: URL(
            string: "https://www.themoviedb.org/review/5488c29bc3a3686f4a00004a"
        )
    )

}
