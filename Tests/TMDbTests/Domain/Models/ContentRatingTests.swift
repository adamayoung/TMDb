//
//  ContentRatingTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ContentRatingTests {

    @Test("JSON decoding of ContentRating", .tags(.decoding))
    func decodeContentRating() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ContentRating.self, fromResource: "content-rating"
        )

        #expect(result.descriptors == contentRating.descriptors)
        #expect(result.countryCode == contentRating.countryCode)
        #expect(result.rating == contentRating.rating)
    }

    private let contentRating = ContentRating(
        descriptors: [],
        countryCode: "US",
        rating: "TV-14"
    )

}
