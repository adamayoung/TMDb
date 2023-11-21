//
//  GenreTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class GenreTests: XCTestCase {

    func testDecodeReturnsGenre() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Genre.self, fromResource: "genre")

        XCTAssertEqual(result.id, genre.id)
        XCTAssertEqual(result.name, genre.name)
    }

    private let genre = Genre(
        id: 28,
        name: "Action"
    )

}
