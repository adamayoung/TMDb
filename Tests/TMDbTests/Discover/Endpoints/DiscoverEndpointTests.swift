@testable import TMDb
import XCTest

final class DiscoverEndpointTests: XCTestCase {

    func testMoviesEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/movie"))

        let url = DiscoverEndpoint.movies().path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesEndpointWithSortedByReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/movie?sort_by=original_title.asc"))

        let url = DiscoverEndpoint.movies(sortedBy: .originalTitle(descending: false)).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesEndpointWithWithPeopleReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/movie?with_people=1,2,3"))

        let url = DiscoverEndpoint.movies(people: [1, 2, 3]).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/movie?page=1"))

        let url = DiscoverEndpoint.movies(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesEndpointWithSortedByAndWithPeopleAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(
            string: "/discover/movie?sort_by=original_title.asc&with_people=1,2,3&page=1")
        )

        let url = DiscoverEndpoint.movies(sortedBy: .originalTitle(descending: false), people: [1, 2, 3], page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/tv"))

        let url = DiscoverEndpoint.tvSeries().path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesEndpointWithSortedByReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/tv?sort_by=first_air_date.asc"))

        let url = DiscoverEndpoint.tvSeries(sortedBy: .firstAirDate(descending: false)).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/tv?page=1"))

        let url = DiscoverEndpoint.tvSeries(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesEndpointWithSortedByAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/tv?sort_by=first_air_date.asc&page=1"))

        let url = DiscoverEndpoint.tvSeries(sortedBy: .firstAirDate(descending: false), page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

}
