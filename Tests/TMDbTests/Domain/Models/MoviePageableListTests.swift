//
//  MoviePageableListTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct MoviePageableListTests {

    @Test("JSON decoding of MoviePageableList", .tags(.decoding))
    func decodeReturnsMoviePageableList() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(MoviePageableList.self, fromResource: "movie-pageable-list")

        #expect(result.page == list.page)
        #expect(result.results == list.results)
        #expect(result.totalResults == list.totalResults)
        #expect(result.totalPages == list.totalPages)
    }

    private let list = MoviePageableList(
        page: 1,
        results: [
            MovieListItem(
                id: 1,
                title: "Movie 1",
                originalTitle: "Movie 1 - a",
                originalLanguage: "en",
                overview: "Overview 1",
                genreIDs: [1, 2, 3]
            ),
            MovieListItem(
                id: 2,
                title: "Movie 2",
                originalTitle: "Movie 2 - a",
                originalLanguage: "en",
                overview: "Overview 2",
                genreIDs: [4, 5, 6]
            ),
            MovieListItem(
                id: 3,
                title: "Movie 3",
                originalTitle: "Movie 3 - a",
                originalLanguage: "en",
                overview: "Overview 3",
                genreIDs: [7, 8, 9]
            )
        ],
        totalResults: 3,
        totalPages: 1
    )

}
