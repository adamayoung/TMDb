//
//  ContentRatingsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ContentRatingsTests {

    @Test("JSON decoding of ContentRatings", .tags(.decoding))
    func decodeContentRatingResult() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ContentRatingResult.self, fromResource: "content-ratings"
        )

        #expect(result == contentRatings)
    }

    private let contentRatings = ContentRatingResult(
        results: [
            ContentRating(
                descriptors: [],
                countryCode: "US",
                rating: "TV-14"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "AU",
                rating: "M"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "RU",
                rating: "12+"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "GB",
                rating: "15"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "BR",
                rating: "12"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "HU",
                rating: "12"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "PH",
                rating: "G"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "MX",
                rating: "A"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "PT",
                rating: "NR"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "ES",
                rating: "16"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "FR",
                rating: "16"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "CA",
                rating: "PG"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "NL",
                rating: "6"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "DE",
                rating: "12"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "DE",
                rating: "16"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "AU",
                rating: "PG"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "KR",
                rating: "15"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "AT",
                rating: "12"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "CH",
                rating: "12"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "PL",
                rating: "16"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "HU",
                rating: "16"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "CZ",
                rating: "15+"
            ),
            ContentRating(
                descriptors: [],
                countryCode: "RO",
                rating: "15"
            )
        ],
        id: 8592
    )
}
