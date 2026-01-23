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
        let result = try JSONDecoder.theMovieDatabase.decode(Review.self, fromResource: "review")

        #expect(result.id == review.id)
        #expect(result.author == review.author)
        #expect(result.content == review.content)
    }

    private let review = Review(
        id: "5488c29bc3a3686f4a00004a",
        author: "Travis Bell",
        content:
        // swiftlint:disable:next line_length
        "Like most of the reviews here, I agree that Guardians of the Galaxy was an absolute hoot. Guardians never takes itself too seriously which makes this movie a whole lot of fun. The cast was perfectly chosen and even though two of the main five were CG, knowing who voiced and acted alongside them completely filled out these characters. Guardians of the Galaxy is one of those rare complete audience pleasers. Good fun for everyone!"
    )

}
