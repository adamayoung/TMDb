@testable import TMDb
import XCTest

class TVShowSortTests: XCTestCase {

    func testPopularityAscendingReturnsRawValue() {
        let expectedResult = "popularity.asc"

        let result = TVShowSort.popularityAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testPopularityDescendingReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = TVShowSort.popularityDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testFirstAirDateAscendingReturnsRawValue() {
        let expectedResult = "first_air_date.asc"

        let result = TVShowSort.firstAirDateAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testFirstAirDateDescendingReturnsRawValue() {
        let expectedResult = "first_air_date.desc"

        let result = TVShowSort.firstAirDateDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageAscendingReturnsRawValue() {
        let expectedResult = "vote_average.asc"

        let result = TVShowSort.voteAverageAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageDescendingReturnsRawValue() {
        let expectedResult = "vote_average.desc"

        let result = TVShowSort.voteAverageDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testDefaultReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = TVShowSort.default.rawValue

        XCTAssertEqual(result, expectedResult)
    }

}

extension TVShowSortTests {

    func testURLAppendingSortByReturnsURL() {
        let expectedResult = URL(string: "/some/path?sort_by=popularity.asc")!

        let result = URL(string: "/some/path")!.appendingSortBy(TVShowSort.popularityAscending)

        XCTAssertEqual(result, expectedResult)
    }

    func testURLAppendingNilSortByReturnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingSortBy(nil as TVShowSort?)

        XCTAssertEqual(result, expectedResult)
    }

}
