@testable import TMDb
import XCTest

final class TVSeriesPageableListTests: XCTestCase {

    func testDecodeReturnsTVSeriesPageableList() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(TVSeriesPageableList.self, fromResource: "tv-series-pageable-list")

        XCTAssertEqual(result.page, list.page)
        XCTAssertEqual(result.results, list.results)
        XCTAssertEqual(result.totalResults, list.totalResults)
        XCTAssertEqual(result.totalPages, list.totalPages)
    }

    private let list = TVSeriesPageableList(
        page: 1,
        results: [
            TVSeries(id: 1, name: "TV Series 1"),
            TVSeries(id: 2, name: "TV Series 2"),
            TVSeries(id: 3, name: "TV Series 3")
        ],
        totalResults: 3,
        totalPages: 1
    )

}
