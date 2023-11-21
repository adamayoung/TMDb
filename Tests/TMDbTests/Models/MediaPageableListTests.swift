//
//  MediaPageableListTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class MediaPageableListTests: XCTestCase {

    func testDecodeReturnsMediaPageableList() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(MediaPageableList.self, fromResource: "media-pageable-list")

        XCTAssertEqual(result.page, list.page)
        XCTAssertEqual(result.results, list.results)
        XCTAssertEqual(result.totalResults, list.totalResults)
        XCTAssertEqual(result.totalPages, list.totalPages)
    }

    private let list = MediaPageableList(
        page: 1,
        results: [
            .movie(Movie(id: 1, title: "Fight Club")),
            .tvSeries(TVSeries(id: 2, name: "The Mrs Bradley Mysteries")),
            .person(Person(id: 51329, name: "Bradley Cooper", gender: .unknown))
        ],
        totalResults: 3,
        totalPages: 1
    )

}
