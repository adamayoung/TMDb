@testable import TMDb
import XCTest

class PageableListResultDTOTests: XCTestCase {

    func testDecodeReturnsPageableListResult() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(PageableListResultDTO<SomeListItem>.self, from: data)

        XCTAssertEqual(result.page, list.page)
        XCTAssertEqual(result.results, list.results)
        XCTAssertEqual(result.totalResults, list.totalResults)
        XCTAssertEqual(result.totalPages, list.totalPages)
    }

    private let json = """
    {
        "page": 1,
        "results": [
            {
                "id": 1
            },
            {
                "id": 2
            },
            {
                "id": 3
            },
            {
                "id": 4
            }
        ],
        "total_results": 4,
        "total_pages": 1
    }
    """

    private let list = PageableListResultDTO<SomeListItem>(
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

private struct SomeListItem: Identifiable, Decodable, Equatable {

    let id: Int

}
