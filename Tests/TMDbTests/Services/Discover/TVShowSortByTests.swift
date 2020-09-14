@testable import TMDb
import XCTest

class TVShowSortByTests: XCTestCase {

    func testPopularityAscendingReturnsRawValue() {
        let expectedResult = "popularity.asc"

        let result = TVShowSortBy.popularityAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testPopularityDescendingReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = TVShowSortBy.popularityDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testFirstAirDateAscendingReturnsRawValue() {
        let expectedResult = "first_air_date.asc"

        let result = TVShowSortBy.firstAirDateAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testFirstAirDateDescendingReturnsRawValue() {
        let expectedResult = "first_air_date.desc"

        let result = TVShowSortBy.firstAirDateDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageAscendingReturnsRawValue() {
        let expectedResult = "vote_average.asc"

        let result = TVShowSortBy.voteAverageAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageDescendingReturnsRawValue() {
        let expectedResult = "vote_average.desc"

        let result = TVShowSortBy.voteAverageDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testDefaultReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = TVShowSortBy.default.rawValue

        XCTAssertEqual(result, expectedResult)
    }

}

extension TVShowSortByTests {

    func testURLAppendingSortByReturnsURL() {
        let expectedResult = URL(string: "/some/path?sort_by=popularity.asc")!

        let result = URL(string: "/some/path")!.appendingSortBy(TVShowSortBy.popularityAscending)

        XCTAssertEqual(result, expectedResult)
    }

    func testURLAppendingNilSortByReturnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingSortBy(nil as TVShowSortBy?)

        XCTAssertEqual(result, expectedResult)
    }

}
