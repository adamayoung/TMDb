//
//  GenreTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct GenreTests {

    @Test("JSON decoding of Genre", .tags(.decoding))
    func decodeGenre() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Genre.self, fromResource: "genre")

        #expect(result.id == genre.id)
        #expect(result.name == genre.name)
    }

    private let genre = Genre(
        id: 28,
        name: "Action"
    )

}
