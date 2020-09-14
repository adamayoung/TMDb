@testable import TMDb
import XCTest

class MoviePageableListTests: XCTestCase {

    func testDecode_returnsMoviePageableList() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(MoviePageableList.self, from: data)

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
                "title": "Movie 1"
            },
            {
                "id": 2,
                "title": "Movie 2"
            },
            {
                "id": 3,
                "title": "Movie 3"
            }
        ],
        "total_pages": 1,
        "total_results": 3
    }
    """

    private let list = MoviePageableList(
        page: 1,
        results: [
            Movie(id: 1, title: "Movie 1"),
            Movie(id: 2, title: "Movie 2"),
            Movie(id: 3, title: "Movie 3"),
        ],
        totalResults: 3,
        totalPages: 1
    )

}
