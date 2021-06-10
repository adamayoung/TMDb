@testable import TMDb
import XCTest

class MovieSortTests: XCTestCase {

    func testPopularityAscendingReturnsRawValue() {
        let expectedResult = "popularity.asc"

        let result = MovieSort.popularity(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testPopularityDescendingReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = MovieSort.popularity(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testReleaseDateAscendingReturnsRawValue() {
        let expectedResult = "release_date.asc"

        let result = MovieSort.releaseDate(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testReleaseDateDescendingReturnsRawValue() {
        let expectedResult = "release_date.desc"

        let result = MovieSort.releaseDate(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testRevenueAscendingReturnsRawValue() {
        let expectedResult = "revenue.asc"

        let result = MovieSort.revenue(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testRevenueDescendingReturnsRawValue() {
        let expectedResult = "revenue.desc"

        let result = MovieSort.revenue(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testPrimaryReleaseDateAscendingAscendingReturnsRawValue() {
        let expectedResult = "primary_release_date.asc"

        let result = MovieSort.primaryReleaseDate(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testPrimaryReleaseDateDescendingDescendingReturnsRawValue() {
        let expectedResult = "primary_release_date.desc"

        let result = MovieSort.primaryReleaseDate(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testOriginalTitleAscendingReturnsRawValue() {
        let expectedResult = "original_title.asc"

        let result = MovieSort.originalTitle(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testOriginalTitleDescendingReturnsRawValue() {
        let expectedResult = "original_title.desc"

        let result = MovieSort.originalTitle(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageAscendingReturnsRawValue() {
        let expectedResult = "vote_average.asc"

        let result = MovieSort.voteAverage(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageDescendingReturnsRawValue() {
        let expectedResult = "vote_average.desc"

        let result = MovieSort.voteAverage(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteCountAscendingReturnsRawValue() {
        let expectedResult = "vote_count.asc"

        let result = MovieSort.voteCount(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteCountDescendingReturnsRawValue() {
        let expectedResult = "vote_count.desc"

        let result = MovieSort.voteCount(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testDefaultReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = MovieSort.default.description

        XCTAssertEqual(result, expectedResult)
    }

}

extension MovieSortTests {

    func testURLAppendingSortByReturnsURL() {
        let expectedResult = URL(string: "/some/path?sort_by=popularity.asc")!

        let result = URL(string: "/some/path")!
            .appendingSortBy(MovieSort.popularity(descending: false))

        XCTAssertEqual(result, expectedResult)
    }

    func testURLAppendingNilSortByReturnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!
            .appendingSortBy(nil as MovieSort?)

        XCTAssertEqual(result, expectedResult)
    }

}
