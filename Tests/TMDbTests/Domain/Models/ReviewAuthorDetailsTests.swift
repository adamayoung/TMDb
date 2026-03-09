//
//  ReviewAuthorDetailsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ReviewAuthorDetailsTests {

    @Test("JSON decoding of ReviewAuthorDetails", .tags(.decoding))
    func decodeReturnsReviewAuthorDetails() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(
                ReviewAuthorDetails.self,
                fromResource: "review-author-details"
            )

        #expect(result.name == "Travis Bell")
        #expect(result.username == "travisbell")
        #expect(
            result.avatarPath
                == URL(string: "/utBEztLMnid37MJOhm4Nfg0Frv6.jpg")
        )
        #expect(result.rating == 8.0)
    }

    @Test(
        "JSON decoding of ReviewAuthorDetails without optional data",
        .tags(.decoding)
    )
    func decodeWithoutOptionalDataReturnsReviewAuthorDetails() throws {
        let json = """
        {
            "name": "Test",
            "username": "test_user",
            "avatar_path": null,
            "rating": null
        }
        """
        let data = try #require(json.data(using: .utf8))
        let result = try JSONDecoder.theMovieDatabase
            .decode(ReviewAuthorDetails.self, from: data)

        #expect(result.name == "Test")
        #expect(result.username == "test_user")
        #expect(result.avatarPath == nil)
        #expect(result.rating == nil)
    }

}
