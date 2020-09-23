@testable import TMDb
import XCTest

class MoviePageableListDTOTests: XCTestCase {

    func testDecodeReturnsMoviePageableList() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(MoviePageableListDTO.self, from: data)

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

    private let list = MoviePageableListDTO(
        page: 1,
        results: [
            MovieDTO(id: 1, title: "Movie 1"),
            MovieDTO(id: 2, title: "Movie 2"),
            MovieDTO(id: 3, title: "Movie 3")
        ],
        totalResults: 3,
        totalPages: 1
    )

}
