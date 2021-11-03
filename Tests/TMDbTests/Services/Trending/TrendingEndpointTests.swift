@testable import TMDb
import XCTest

final class TrendingEndpointTests: XCTestCase {

    func testTrendingMoviesEndpointReturnsURL() {
        let expectedURL = URL(string: "/trending/movie/day")!

        let url = TrendingEndpoint.movies().url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/trending/movie/day?page=1")!

        let url = TrendingEndpoint.movies(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpointWithTimeWindowDayReturnsURL() {
        let expectedURL = URL(string: "/trending/movie/day")!

        let url = TrendingEndpoint.movies(timeWindow: .day).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpointWithTimeWindowDayAndPageReturnsURL() {
        let expectedURL = URL(string: "/trending/movie/day?page=1")!

        let url = TrendingEndpoint.movies(timeWindow: .day, page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpointWithTimeWindowWeekReturnsURL() {
        let expectedURL = URL(string: "/trending/movie/week")!

        let url = TrendingEndpoint.movies(timeWindow: .week).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpointWithTimeWindowWeekAndPageReturnsURL() {
        let expectedURL = URL(string: "/trending/movie/week?page=1")!

        let url = TrendingEndpoint.movies(timeWindow: .week, page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpointReturnsURL() {
        let expectedURL = URL(string: "/trending/tv/day")!

        let url = TrendingEndpoint.tvShows().url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/trending/tv/day?page=1")!

        let url = TrendingEndpoint.tvShows(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpointWithTimeWindowDayReturnsURL() {
        let expectedURL = URL(string: "/trending/tv/day")!

        let url = TrendingEndpoint.tvShows(timeWindow: .day).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpointWithTimeWindowDayAndPageReturnsURL() {
        let expectedURL = URL(string: "/trending/tv/day?page=1")!

        let url = TrendingEndpoint.tvShows(timeWindow: .day, page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpointWithTimeWindowWeekReturnsURL() {
        let expectedURL = URL(string: "/trending/tv/week")!

        let url = TrendingEndpoint.tvShows(timeWindow: .week).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpointWithTimeWindowWeekAndPageReturnsURL() {
        let expectedURL = URL(string: "/trending/tv/week?page=1")!

        let url = TrendingEndpoint.tvShows(timeWindow: .week, page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpointReturnsURL() {
        let expectedURL = URL(string: "/trending/person/day")!

        let url = TrendingEndpoint.people().url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/trending/person/day?page=1")!

        let url = TrendingEndpoint.people(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpointWithTimeWindowDayReturnsURL() {
        let expectedURL = URL(string: "/trending/person/day")!

        let url = TrendingEndpoint.people(timeWindow: .day).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpointWithTimeWindowDayAndPageReturnsURL() {
        let expectedURL = URL(string: "/trending/person/day?page=1")!

        let url = TrendingEndpoint.people(timeWindow: .day, page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpointWithTimeWindowWeekReturnsURL() {
        let expectedURL = URL(string: "/trending/person/week")!

        let url = TrendingEndpoint.people(timeWindow: .week).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpointWithTimeWindowWeekAndPageReturnsURL() {
        let expectedURL = URL(string: "/trending/person/week?page=1")!

        let url = TrendingEndpoint.people(timeWindow: .week, page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

}
