@testable import TMDb
import XCTest

final class MoviePageableListTests: XCTestCase {

    func testDecodeReturnsMoviePageableList() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(MoviePageableList.self, fromResource: "movie-pageable-list")

        XCTAssertEqual(result.page, list.page)
        XCTAssertEqual(result.results, list.results)
        XCTAssertEqual(result.totalResults, list.totalResults)
        XCTAssertEqual(result.totalPages, list.totalPages)
    }

    private let list = MoviePageableList(
        page: 1,
        results: [
            Movie(id: 1, title: "Movie 1"),
            Movie(id: 2, title: "Movie 2"),
            Movie(id: 3, title: "Movie 3")
        ],
        totalResults: 3,
        totalPages: 1
    )

}
