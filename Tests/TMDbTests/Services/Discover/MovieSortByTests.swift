@testable import TMDb
import XCTest

class MovieSortByTests: XCTestCase {

    func testPopularityAscending_returnsRawValue() {
        let expectedResult = "popularity.asc"

        let result = MovieSortBy.popularityAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testPopularityDescending_returnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = MovieSortBy.popularityDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testReleaseDateAscending_returnsRawValue() {
        let expectedResult = "release_date.asc"

        let result = MovieSortBy.releaseDateAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testReleaseDateDescending_returnsRawValue() {
        let expectedResult = "release_date.desc"

        let result = MovieSortBy.releaseDateDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testRevenueAscending_returnsRawValue() {
        let expectedResult = "revenue.asc"

        let result = MovieSortBy.revenueAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testRevenueDescending_returnsRawValue() {
        let expectedResult = "revenue.desc"

        let result = MovieSortBy.revenueDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testPrimaryReleaseDateAscendingAscending_returnsRawValue() {
        let expectedResult = "primary_release_date.asc"

        let result = MovieSortBy.primaryReleaseDateAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testPrimaryReleaseDateDescendingDescending_returnsRawValue() {
        let expectedResult = "primary_release_date.desc"

        let result = MovieSortBy.primaryReleaseDateDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testOriginalTitleAscending_returnsRawValue() {
        let expectedResult = "original_title.asc"

        let result = MovieSortBy.originalTitleAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testOriginalTitleDescending_returnsRawValue() {
        let expectedResult = "original_title.desc"

        let result = MovieSortBy.originalTitleDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageAscending_returnsRawValue() {
        let expectedResult = "vote_average.asc"

        let result = MovieSortBy.voteAverageAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageDescending_returnsRawValue() {
        let expectedResult = "vote_average.desc"

        let result = MovieSortBy.voteAverageDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteCountAscending_returnsRawValue() {
        let expectedResult = "vote_count.asc"

        let result = MovieSortBy.voteCountAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteCountDescending_returnsRawValue() {
        let expectedResult = "vote_count.desc"

        let result = MovieSortBy.voteCountDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testDefault_returnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = MovieSortBy.default.rawValue

        XCTAssertEqual(result, expectedResult)
    }

}

extension MovieSortByTests {

    func testURLAppendingSortBy_returnsURL() {
        let expectedResult = URL(string: "/some/path?sort_by=popularity.asc")!

        let result = URL(string: "/some/path")!.appendingSortBy(MovieSortBy.popularityAscending)

        XCTAssertEqual(result, expectedResult)
    }

    func testURLAppendingNilSortBy_returnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingSortBy(nil as MovieSortBy?)

        XCTAssertEqual(result, expectedResult)
    }

}
