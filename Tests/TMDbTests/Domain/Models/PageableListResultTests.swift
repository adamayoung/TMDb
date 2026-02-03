//
//  PageableListResultTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct PageableListResultTests {

    @Test("JSON decoding of PageableListResult", .tags(.decoding))
    func decodeReturnsPageableListResult() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(PageableListResult<SomeListItem>.self, fromResource: "pageable-list-result")

        #expect(result.page == list.page)
        #expect(result.results == list.results)
        #expect(result.totalResults == list.totalResults)
        #expect(result.totalPages == list.totalPages)
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
