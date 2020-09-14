@testable import TMDb
import XCTest

class DiscoverEndpointTests: XCTestCase {

    func testMoviesEndpointReturnsURL() {
        let expectedURL = URL(string: "/discover/movie")!

        let url = DiscoverEndpoint.movies().url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesEndpointWithSortedByReturnsURL() {
        let expectedURL = URL(string: "/discover/movie?sort_by=original_title.asc")!

        let url = DiscoverEndpoint.movies(sortBy: .originalTitleAscending).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesEndpointWithWithPeopleReturnsURL() {
        let expectedURL = URL(string: "/discover/movie?with_people=1,2,3")!

        let url = DiscoverEndpoint.movies(withPeople: [1, 2, 3]).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/discover/movie?page=1")!

        let url = DiscoverEndpoint.movies(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesEndpointWithSortedByAndWithPeopleAndPageReturnsURL() {
        let expectedURL = URL(string: "/discover/movie?sort_by=original_title.asc&with_people=1,2,3&page=1")!

        let url = DiscoverEndpoint.movies(sortBy: .originalTitleAscending, withPeople: [1, 2, 3], page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowsEndpointReturnsURL() {
        let expectedURL = URL(string: "/discover/tv")!

        let url = DiscoverEndpoint.tvShows().url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowsEndpointWithSortedByReturnsURL() {
        let expectedURL = URL(string: "/discover/tv?sort_by=first_air_date.asc")!

        let url = DiscoverEndpoint.tvShows(sortBy: .firstAirDateAscending).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowsEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/discover/tv?page=1")!

        let url = DiscoverEndpoint.tvShows(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowsEndpointWithSortedByAndPageReturnsURL() {
        let expectedURL = URL(string: "/discover/tv?sort_by=first_air_date.asc&page=1")!

        let url = DiscoverEndpoint.tvShows(sortBy: .firstAirDateAscending, page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

}
