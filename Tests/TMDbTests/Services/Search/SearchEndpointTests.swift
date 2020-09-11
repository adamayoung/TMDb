@testable import TMDb
import XCTest

class SearchEndpointTests: XCTestCase {

    func testMultiSearchEndpoint_returnsURL() {
        let expectedURL = URL(string: "/search/multi?query=Game%20of%20Thrones")!

        let url = SearchEndpoint.multi(query: "Game of Thrones").url

        XCTAssertEqual(url, expectedURL)
    }

    func testMultiSearchEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/search/multi?query=Game%20of%20Thrones&page=2")!

        let url = SearchEndpoint.multi(query: "Game of Thrones", page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesSearchEndpoint_returnsURL() {
        let expectedURL = URL(string: "/search/movie?query=Back%20to%20the%20Future")!

        let url = SearchEndpoint.movies(query: "Back to the Future").url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesSearchEndpoint_withYear_returnsURL() {
        let expectedURL = URL(string: "/search/movie?query=Back%20to%20the%20Future&year=1985")!

        let url = SearchEndpoint.movies(query: "Back to the Future", year: 1985).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesSearchEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/search/movie?query=Back%20to%20the%20Future&page=2")!

        let url = SearchEndpoint.movies(query: "Back to the Future", page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesSearchEndpoint_withYearAndPage_returnsURL() {
        let expectedURL = URL(string: "/search/movie?query=Back%20to%20the%20Future&year=1985&page=2")!

        let url = SearchEndpoint.movies(query: "Back to the Future", year: 1985, page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowsSearchEndpoint_returnsURL() {
        let expectedURL = URL(string: "/search/tv?query=The%20Boys")!

        let url = SearchEndpoint.tvShows(query: "The Boys").url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowsSearchEndpoint_withFirstAirDateYear_returnsURL() {
        let expectedURL = URL(string: "/search/tv?query=The%20Boys&first_air_date_year=2020")!

        let url = SearchEndpoint.tvShows(query: "The Boys", firstAirDateYear: 2020).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowsSearchEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/search/tv?query=The%20Boys&page=2")!

        let url = SearchEndpoint.tvShows(query: "The Boys", page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowsSearchEndpoint_withYearAndPage_returnsURL() {
        let expectedURL = URL(string: "/search/tv?query=The%20Boys&first_air_date_year=2020&page=2")!

        let url = SearchEndpoint.tvShows(query: "The Boys", firstAirDateYear: 2020, page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testPeopleSearchEndpoint_returnsURL() {
        let expectedURL = URL(string: "/search/person?query=Robert%20Downey")!

        let url = SearchEndpoint.people(query: "Robert Downey").url

        XCTAssertEqual(url, expectedURL)
    }

    func testPeopleSearchEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/search/person?query=Robert%20Downey&page=2")!

        let url = SearchEndpoint.people(query: "Robert Downey", page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

}
