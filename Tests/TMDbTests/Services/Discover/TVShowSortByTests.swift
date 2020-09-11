@testable import TMDb
import XCTest

class TVShowSortByTests: XCTestCase {

    func testPopularityAscending_returnsRawValue() {
        let expectedResult = "popularity.asc"

        let result = TVShowSortBy.popularityAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testPopularityDescending_returnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = TVShowSortBy.popularityDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testFirstAirDateAscending_returnsRawValue() {
        let expectedResult = "first_air_date.asc"

        let result = TVShowSortBy.firstAirDateAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testFirstAirDateDescending_returnsRawValue() {
        let expectedResult = "first_air_date.desc"

        let result = TVShowSortBy.firstAirDateDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageAscending_returnsRawValue() {
        let expectedResult = "vote_average.asc"

        let result = TVShowSortBy.voteAverageAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageDescending_returnsRawValue() {
        let expectedResult = "vote_average.desc"

        let result = TVShowSortBy.voteAverageDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testDefault_returnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = TVShowSortBy.default.rawValue

        XCTAssertEqual(result, expectedResult)
    }

}

extension TVShowSortByTests {

    func testURLAppendingSortBy_returnsURL() {
        let expectedResult = URL(string: "/some/path?sort_by=popularity.asc")!

        let result = URL(string: "/some/path")!.appendingSortBy(TVShowSortBy.popularityAscending)

        XCTAssertEqual(result, expectedResult)
    }

    func testURLAppendingNilSortBy_returnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingSortBy(nil as TVShowSortBy?)

        XCTAssertEqual(result, expectedResult)
    }

}
