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

    func testTrendingTVSeriesEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/tv/day"))

        let url = TrendingEndpoint.tvSeries().path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVSeriesEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/tv/day?page=1"))

        let url = TrendingEndpoint.tvSeries(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVSeriesEndpointWithTimeWindowDayReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/tv/day"))

        let url = TrendingEndpoint.tvSeries(timeWindow: .day).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVSeriesEndpointWithTimeWindowDayAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/tv/day?page=1"))

        let url = TrendingEndpoint.tvSeries(timeWindow: .day, page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVSeriesEndpointWithTimeWindowWeekReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/tv/week"))

        let url = TrendingEndpoint.tvSeries(timeWindow: .week).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTrendingTVSeriesEndpointWithTimeWindowWeekAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/trending/tv/week?page=1"))

        let url = TrendingEndpoint.tvSeries(timeWindow: .week, page: 1).path

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
