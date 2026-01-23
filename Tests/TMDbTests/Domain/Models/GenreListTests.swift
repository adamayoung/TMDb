//
//  GenreListTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct GenreListTests {

    @Test("JSON decoding of GenreList", .tags(.decoding))
    func decodeGenreList() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            GenreList.self, fromResource: "genres-list"
        )

        #expect(result.genres == genreList.genres)
    }

    private let genreList = GenreList(
        genres: [
            .init(id: 28, name: "Action")
        ]
    )

}
