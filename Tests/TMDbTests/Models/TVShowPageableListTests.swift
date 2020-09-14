@testable import TMDb
import XCTest

class TVShowPageableListTests: XCTestCase {

    func testDecode_returnsTVShowPageableList() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(TVShowPageableList.self, from: data)

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
                "id": 1,
                "name": "TV Show 1"
            },
            {
                "id": 2,
                "name": "TV Show 2"
            },
            {
                "id": 3,
                "name": "TV Show 3"
            }
        ],
        "total_pages": 1,
        "total_results": 3
    }
    """

    private let list = TVShowPageableList(
        page: 1,
        results: [
            TVShow(id: 1, name: "TV Show 1"),
            TVShow(id: 2, name: "TV Show 2"),
            TVShow(id: 3, name: "TV Show 3"),
        ],
        totalResults: 3,
        totalPages: 1
    )

}
