@testable import TMDb
import XCTest

final class SearchEndpointTests: XCTestCase {

    func testMultiSearchEndpointReturnsURL() {
        let expectedURL = URL(string: "/search/multi?query=Game%20of%20Thrones")!

        let url = SearchEndpoint.multi(query: "Game of Thrones").url

        XCTAssertEqual(url, expectedURL)
    }

    func testMultiSearchEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/search/multi?query=Game%20of%20Thrones&page=2")!

        let url = SearchEndpoint.multi(query: "Game of Thrones", page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesSearchEndpointReturnsURL() {
        let expectedURL = URL(string: "/search/movie?query=Back%20to%20the%20Future")!

        let url = SearchEndpoint.movies(query: "Back to the Future").url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesSearchEndpointWithYearReturnsURL() {
        let expectedURL = URL(string: "/search/movie?query=Back%20to%20the%20Future&year=1985")!

        let url = SearchEndpoint.movies(query: "Back to the Future", year: 1985).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesSearchEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/search/movie?query=Back%20to%20the%20Future&page=2")!

        let url = SearchEndpoint.movies(query: "Back to the Future", page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesSearchEndpointWithYearAndPageReturnsURL() {
        let expectedURL = URL(string: "/search/movie?query=Back%20to%20the%20Future&year=1985&page=2")!

        let url = SearchEndpoint.movies(query: "Back to the Future", year: 1985, page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowsSearchEndpointReturnsURL() {
        let expectedURL = URL(string: "/search/tv?query=The%20Boys")!

        let url = SearchEndpoint.tvShows(query: "The Boys").url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowsSearchEndpointWithFirstAirDateYearReturnsURL() {
        let expectedURL = URL(string: "/search/tv?query=The%20Boys&first_air_date_year=2020")!

        let url = SearchEndpoint.tvShows(query: "The Boys", firstAirDateYear: 2020).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowsSearchEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/search/tv?query=The%20Boys&page=2")!

        let url = SearchEndpoint.tvShows(query: "The Boys", page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowsSearchEndpointWithYearAndPageReturnsURL() {
        let expectedURL = URL(string: "/search/tv?query=The%20Boys&first_air_date_year=2020&page=2")!

        let url = SearchEndpoint.tvShows(query: "The Boys", firstAirDateYear: 2020, page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testPeopleSearchEndpointReturnsURL() {
        let expectedURL = URL(string: "/search/person?query=Robert%20Downey")!

        let url = SearchEndpoint.people(query: "Robert Downey").url

        XCTAssertEqual(url, expectedURL)
    }

    func testPeopleSearchEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/search/person?query=Robert%20Downey&page=2")!

        let url = SearchEndpoint.people(query: "Robert Downey", page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

}
