@testable import TMDb
import XCTest

final class TVShowSortTests: XCTestCase {

    func testPopularityAscendingReturnsRawValue() {
        let expectedResult = "popularity.asc"

        let result = TVShowSort.popularity(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testPopularityDescendingReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = TVShowSort.popularity(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testFirstAirDateAscendingReturnsRawValue() {
        let expectedResult = "first_air_date.asc"

        let result = TVShowSort.firstAirDate(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testFirstAirDateDescendingReturnsRawValue() {
        let expectedResult = "first_air_date.desc"

        let result = TVShowSort.firstAirDate(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageAscendingReturnsRawValue() {
        let expectedResult = "vote_average.asc"

        let result = TVShowSort.voteAverage(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageDescendingReturnsRawValue() {
        let expectedResult = "vote_average.desc"

        let result = TVShowSort.voteAverage(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testDefaultReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = TVShowSort.default.description

        XCTAssertEqual(result, expectedResult)
    }

}

extension TVShowSortTests {

    func testURLAppendingSortByReturnsURL() {
        let expectedResult = URL(string: "/some/path?sort_by=popularity.asc")!

        let result = URL(string: "/some/path")!
            .appendingSortBy(TVShowSort.popularity(descending: false))

        XCTAssertEqual(result, expectedResult)
    }

    func testURLAppendingNilSortByReturnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!
            .appendingSortBy(nil as TVShowSort?)

        XCTAssertEqual(result, expectedResult)
    }

}
