//
//  PageableListResultTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class PageableListResultTests: XCTestCase {

    func testDecodeReturnsPageableListResult() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(PageableListResult<SomeListItem>.self, fromResource: "pageable-list-result")

        XCTAssertEqual(result.page, list.page)
        XCTAssertEqual(result.results, list.results)
        XCTAssertEqual(result.totalResults, list.totalResults)
        XCTAssertEqual(result.totalPages, list.totalPages)
    }

    private let list = PageableListResult<SomeListItem>(
        page: 1,
        results: [
            SomeListItem(id: 1),
            SomeListItem(id: 2),
            SomeListItem(id: 3),
            SomeListItem(id: 4)
        ],
        totalResults: 4,
        totalPages: 1
    )

}

private struct SomeListItem: Identifiable, Codable, Equatable, Hashable {

    let id: Int

}
