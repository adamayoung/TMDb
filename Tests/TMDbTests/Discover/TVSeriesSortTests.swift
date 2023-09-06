@testable import TMDb
import XCTest

final class TVSeriesSortTests: XCTestCase {

    func testPopularityAscendingReturnsRawValue() {
        let expectedResult = "popularity.asc"

        let result = TVSeriesSort.popularity(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testPopularityDescendingReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = TVSeriesSort.popularity(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testFirstAirDateAscendingReturnsRawValue() {
        let expectedResult = "first_air_date.asc"

        let result = TVSeriesSort.firstAirDate(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testFirstAirDateDescendingReturnsRawValue() {
        let expectedResult = "first_air_date.desc"

        let result = TVSeriesSort.firstAirDate(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageAscendingReturnsRawValue() {
        let expectedResult = "vote_average.asc"

        let result = TVSeriesSort.voteAverage(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageDescendingReturnsRawValue() {
        let expectedResult = "vote_average.desc"

        let result = TVSeriesSort.voteAverage(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

}

extension TVSeriesSortTests {

    func testURLAppendingSortByReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?sort_by=popularity.asc"))

        let result = try XCTUnwrap(URL(string: "/some/path"))
            .appendingSortBy(TVSeriesSort.popularity(descending: false))

        XCTAssertEqual(result, expectedResult)
    }

    func testURLAppendingNilSortByReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path"))

        let result = try XCTUnwrap(URL(string: "/some/path"))
            .appendingSortBy(nil as TVSeriesSort?)

        XCTAssertEqual(result, expectedResult)
    }

}
