@testable import TMDb
import XCTest

final class TrendingEndpointTests: XCTestCase {

    func testTrendingMoviesEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/movie/day"))

        let url = TrendingEndpoint.movies().path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/movie/day?page=1"))

        let url = TrendingEndpoint.movies(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpointWithTimeWindowDayReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/movie/day"))

        let url = TrendingEndpoint.movies(timeWindow: .day).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpointWithTimeWindowDayAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/movie/day?page=1"))

        let url = TrendingEndpoint.movies(timeWindow: .day, page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpointWithTimeWindowWeekReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/movie/week"))

        let url = TrendingEndpoint.movies(timeWindow: .week).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingMoviesEndpointWithTimeWindowWeekAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/movie/week?page=1"))

        let url = TrendingEndpoint.movies(timeWindow: .week, page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/tv/day"))

        let url = TrendingEndpoint.tvShows().path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/tv/day?page=1"))

        let url = TrendingEndpoint.tvShows(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpointWithTimeWindowDayReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/tv/day"))

        let url = TrendingEndpoint.tvShows(timeWindow: .day).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpointWithTimeWindowDayAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/tv/day?page=1"))

        let url = TrendingEndpoint.tvShows(timeWindow: .day, page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpointWithTimeWindowWeekReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/tv/week"))

        let url = TrendingEndpoint.tvShows(timeWindow: .week).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVShowsEndpointWithTimeWindowWeekAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/tv/week?page=1"))

        let url = TrendingEndpoint.tvShows(timeWindow: .week, page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/person/day"))

        let url = TrendingEndpoint.people().path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/person/day?page=1"))

        let url = TrendingEndpoint.people(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpointWithTimeWindowDayReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/person/day"))

        let url = TrendingEndpoint.people(timeWindow: .day).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpointWithTimeWindowDayAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/person/day?page=1"))

        let url = TrendingEndpoint.people(timeWindow: .day, page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpointWithTimeWindowWeekReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/person/week"))

        let url = TrendingEndpoint.people(timeWindow: .week).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingPeopleEndpointWithTimeWindowWeekAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/person/week?page=1"))

        let url = TrendingEndpoint.people(timeWindow: .week, page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

}
