@testable import TMDb
import XCTest

class MovieSortByTests: XCTestCase {

    func testPopularityAscendingReturnsRawValue() {
        let expectedResult = "popularity.asc"

        let result = MovieSortBy.popularityAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testPopularityDescendingReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = MovieSortBy.popularityDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testReleaseDateAscendingReturnsRawValue() {
        let expectedResult = "release_date.asc"

        let result = MovieSortBy.releaseDateAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testReleaseDateDescendingReturnsRawValue() {
        let expectedResult = "release_date.desc"

        let result = MovieSortBy.releaseDateDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testRevenueAscendingReturnsRawValue() {
        let expectedResult = "revenue.asc"

        let result = MovieSortBy.revenueAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testRevenueDescendingReturnsRawValue() {
        let expectedResult = "revenue.desc"

        let result = MovieSortBy.revenueDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testPrimaryReleaseDateAscendingAscendingReturnsRawValue() {
        let expectedResult = "primary_release_date.asc"

        let result = MovieSortBy.primaryReleaseDateAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testPrimaryReleaseDateDescendingDescendingReturnsRawValue() {
        let expectedResult = "primary_release_date.desc"

        let result = MovieSortBy.primaryReleaseDateDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testOriginalTitleAscendingReturnsRawValue() {
        let expectedResult = "original_title.asc"

        let result = MovieSortBy.originalTitleAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testOriginalTitleDescendingReturnsRawValue() {
        let expectedResult = "original_title.desc"

        let result = MovieSortBy.originalTitleDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageAscendingReturnsRawValue() {
        let expectedResult = "vote_average.asc"

        let result = MovieSortBy.voteAverageAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageDescendingReturnsRawValue() {
        let expectedResult = "vote_average.desc"

        let result = MovieSortBy.voteAverageDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteCountAscendingReturnsRawValue() {
        let expectedResult = "vote_count.asc"

        let result = MovieSortBy.voteCountAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteCountDescendingReturnsRawValue() {
        let expectedResult = "vote_count.desc"

        let result = MovieSortBy.voteCountDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testDefaultReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = MovieSortBy.default.rawValue

        XCTAssertEqual(result, expectedResult)
    }

}

extension MovieSortByTests {

    func testURLAppendingSortByReturnsURL() {
        let expectedResult = URL(string: "/some/path?sort_by=popularity.asc")!

        let result = URL(string: "/some/path")!.appendingSortBy(MovieSortBy.popularityAscending)

        XCTAssertEqual(result, expectedResult)
    }

    func testURLAppendingNilSortByReturnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingSortBy(nil as MovieSortBy?)

        XCTAssertEqual(result, expectedResult)
    }

}
