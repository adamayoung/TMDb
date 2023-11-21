//
//  ReviewTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class ReviewTests: XCTestCase {

    func testDecodeReturnsReview() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Review.self, fromResource: "review")

        XCTAssertEqual(result.id, review.id)
        XCTAssertEqual(result.author, review.author)
        XCTAssertEqual(result.content, review.content)
    }

    // swiftlint:disable line_length
    private let review = Review(
        id: "5488c29bc3a3686f4a00004a",
        author: "Travis Bell",
        content: "Like most of the reviews here, I agree that Guardians of the Galaxy was an absolute hoot. Guardians never takes itself too seriously which makes this movie a whole lot of fun. The cast was perfectly chosen and even though two of the main five were CG, knowing who voiced and acted alongside them completely filled out these characters. Guardians of the Galaxy is one of those rare complete audience pleasers. Good fun for everyone!"
    )
    // swiftlint:enable line_length

}
