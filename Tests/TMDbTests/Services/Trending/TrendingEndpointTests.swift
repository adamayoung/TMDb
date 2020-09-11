@testable import TMDb
import XCTest

class TrendingEndpointTests: XCTestCase {

    func testTrendingMoviesEndpoint_returnsURL() {
        let expectedURL = URL(string: "/trending/movie/day")!

        let url = TrendingEndpoint.movies().url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/trending/movie/day?page=1")!

        let url = TrendingEndpoint.movies(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpoint_withTimeWindowDay_returnsURL() {
        let expectedURL = URL(string: "/trending/movie/day")!

        let url = TrendingEndpoint.movies(timeWindow: .day).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpoint_withTimeWindowDayAndPage_returnsURL() {
        let expectedURL = URL(string: "/trending/movie/day?page=1")!

        let url = TrendingEndpoint.movies(timeWindow: .day, page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpoint_withTimeWindowWeek_returnsURL() {
        let expectedURL = URL(string: "/trending/movie/week")!

        let url = TrendingEndpoint.movies(timeWindow: .week).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpoint_withTimeWindowWeekAndPage_returnsURL() {
        let expectedURL = URL(string: "/trending/movie/week?page=1")!

        let url = TrendingEndpoint.movies(timeWindow: .week, page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/trending/tv/day")!

        let url = TrendingEndpoint.tvShows().url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/trending/tv/day?page=1")!

        let url = TrendingEndpoint.tvShows(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpoint_withTimeWindowDay_returnsURL() {
        let expectedURL = URL(string: "/trending/tv/day")!

        let url = TrendingEndpoint.tvShows(timeWindow: .day).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpoint_withTimeWindowDayAndPage_returnsURL() {
        let expectedURL = URL(string: "/trending/tv/day?page=1")!

        let url = TrendingEndpoint.tvShows(timeWindow: .day, page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpoint_withTimeWindowWeek_returnsURL() {
        let expectedURL = URL(string: "/trending/tv/week")!

        let url = TrendingEndpoint.tvShows(timeWindow: .week).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpoint_withTimeWindowWeekAndPage_returnsURL() {
        let expectedURL = URL(string: "/trending/tv/week?page=1")!

        let url = TrendingEndpoint.tvShows(timeWindow: .week, page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpoint_returnsURL() {
        let expectedURL = URL(string: "/trending/person/day")!

        let url = TrendingEndpoint.people().url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/trending/person/day?page=1")!

        let url = TrendingEndpoint.people(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpoint_withTimeWindowDay_returnsURL() {
        let expectedURL = URL(string: "/trending/person/day")!

        let url = TrendingEndpoint.people(timeWindow: .day).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpoint_withTimeWindowDayAndPage_returnsURL() {
        let expectedURL = URL(string: "/trending/person/day?page=1")!

        let url = TrendingEndpoint.people(timeWindow: .day, page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpoint_withTimeWindowWeek_returnsURL() {
        let expectedURL = URL(string: "/trending/person/week")!

        let url = TrendingEndpoint.people(timeWindow: .week).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpoint_withTimeWindowWeekAndPage_returnsURL() {
        let expectedURL = URL(string: "/trending/person/week?page=1")!

        let url = TrendingEndpoint.people(timeWindow: .week, page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

}
