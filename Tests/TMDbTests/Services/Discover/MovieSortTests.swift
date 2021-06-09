@testable import TMDb
import XCTest

class MovieSortTests: XCTestCase {

    func testPopularityAscendingReturnsRawValue() {
        let expectedResult = "popularity.asc"

        let result = MovieSort.popularityAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testPopularityDescendingReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = MovieSort.popularityDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testReleaseDateAscendingReturnsRawValue() {
        let expectedResult = "release_date.asc"

        let result = MovieSort.releaseDateAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testReleaseDateDescendingReturnsRawValue() {
        let expectedResult = "release_date.desc"

        let result = MovieSort.releaseDateDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testRevenueAscendingReturnsRawValue() {
        let expectedResult = "revenue.asc"

        let result = MovieSort.revenueAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testRevenueDescendingReturnsRawValue() {
        let expectedResult = "revenue.desc"

        let result = MovieSort.revenueDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testPrimaryReleaseDateAscendingAscendingReturnsRawValue() {
        let expectedResult = "primary_release_date.asc"

        let result = MovieSort.primaryReleaseDateAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testPrimaryReleaseDateDescendingDescendingReturnsRawValue() {
        let expectedResult = "primary_release_date.desc"

        let result = MovieSort.primaryReleaseDateDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testOriginalTitleAscendingReturnsRawValue() {
        let expectedResult = "original_title.asc"

        let result = MovieSort.originalTitleAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testOriginalTitleDescendingReturnsRawValue() {
        let expectedResult = "original_title.desc"

        let result = MovieSort.originalTitleDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageAscendingReturnsRawValue() {
        let expectedResult = "vote_average.asc"

        let result = MovieSort.voteAverageAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageDescendingReturnsRawValue() {
        let expectedResult = "vote_average.desc"

        let result = MovieSort.voteAverageDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteCountAscendingReturnsRawValue() {
        let expectedResult = "vote_count.asc"

        let result = MovieSort.voteCountAscending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteCountDescendingReturnsRawValue() {
        let expectedResult = "vote_count.desc"

        let result = MovieSort.voteCountDescending.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testDefaultReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = MovieSort.default.rawValue

        XCTAssertEqual(result, expectedResult)
    }

}

extension MovieSortTests {

    func testURLAppendingSortByReturnsURL() {
        let expectedResult = URL(string: "/some/path?sort_by=popularity.asc")!

        let result = URL(string: "/some/path")!.appendingSortBy(MovieSort.popularityAscending)

        XCTAssertEqual(result, expectedResult)
    }

    func testURLAppendingNilSortByReturnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingSortBy(nil as MovieSort?)

        XCTAssertEqual(result, expectedResult)
    }

}
