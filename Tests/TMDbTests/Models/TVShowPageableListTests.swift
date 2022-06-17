@testable import TMDb
import XCTest

final class TVShowPageableListTests: XCTestCase {

    func testDecodeReturnsTVShowPageableList() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(TVShowPageableList.self, fromResource: "tv-show-pageable-list")

        XCTAssertEqual(result.page, list.page)
        XCTAssertEqual(result.results, list.results)
        XCTAssertEqual(result.totalResults, list.totalResults)
        XCTAssertEqual(result.totalPages, list.totalPages)
    }

    private let list = TVShowPageableList(
        page: 1,
        results: [
            TVShow(id: 1, name: "TV Show 1"),
            TVShow(id: 2, name: "TV Show 2"),
            TVShow(id: 3, name: "TV Show 3")
        ],
        totalResults: 3,
        totalPages: 1
    )

}
