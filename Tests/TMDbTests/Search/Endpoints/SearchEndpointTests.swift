@testable import TMDb
import XCTest

final class SearchEndpointTests: XCTestCase {

    func testMultiSearchEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/search/multi?query=Game%20of%20Thrones"))

        let url = SearchEndpoint.multi(query: "Game of Thrones").path

        XCTAssertEqual(url, expectedURL)
    }

    func testMultiSearchEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/search/multi?query=Game%20of%20Thrones&page=2"))

        let url = SearchEndpoint.multi(query: "Game of Thrones", page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesSearchEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/search/movie?query=Back%20to%20the%20Future"))

        let url = SearchEndpoint.movies(query: "Back to the Future").path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesSearchEndpointWithYearReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/search/movie?query=Back%20to%20the%20Future&year=1985"))

        let url = SearchEndpoint.movies(query: "Back to the Future", year: 1985).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesSearchEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/search/movie?query=Back%20to%20the%20Future&page=2"))

        let url = SearchEndpoint.movies(query: "Back to the Future", page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesSearchEndpointWithYearAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/search/movie?query=Back%20to%20the%20Future&year=1985&page=2"))

        let url = SearchEndpoint.movies(query: "Back to the Future", year: 1985, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesSearchEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/search/tv?query=The%20Boys"))

        let url = SearchEndpoint.tvSeries(query: "The Boys").path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesSearchEndpointWithFirstAirDateYearReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/search/tv?query=The%20Boys&first_air_date_year=2020"))

        let url = SearchEndpoint.tvSeries(query: "The Boys", firstAirDateYear: 2020).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesSearchEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/search/tv?query=The%20Boys&page=2"))

        let url = SearchEndpoint.tvSeries(query: "The Boys", page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesSearchEndpointWithYearAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/search/tv?query=The%20Boys&first_air_date_year=2020&page=2"))

        let url = SearchEndpoint.tvSeries(query: "The Boys", firstAirDateYear: 2020, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testPeopleSearchEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/search/person?query=Robert%20Downey"))

        let url = SearchEndpoint.people(query: "Robert Downey").path

        XCTAssertEqual(url, expectedURL)
    }

    func testPeopleSearchEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/search/person?query=Robert%20Downey&page=2"))

        let url = SearchEndpoint.people(query: "Robert Downey", page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

}
