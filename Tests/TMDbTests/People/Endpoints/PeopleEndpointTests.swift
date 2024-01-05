@testable import TMDb
import XCTest

final class PeopleEndpointTests: XCTestCase {

    func testPersonDetailsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/1"))

        let url = PeopleEndpoint.details(personID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonCombinedCreditsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/1/combined_credits"))

        let url = PeopleEndpoint.combinedCredits(personID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonMovieCreditsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/1/movie_credits"))

        let url = PeopleEndpoint.movieCredits(personID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonTVSeriesCreditsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/1/tv_credits"))

        let url = PeopleEndpoint.tvSeriesCredits(personID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonImagesEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/1/images"))

        let url = PeopleEndpoint.images(personID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testPopularPeopleEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/popular"))

        let url = PeopleEndpoint.popular().path

        XCTAssertEqual(url, expectedURL)
    }

    func testPopularPeopleEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/popular?page=1"))

        let url = PeopleEndpoint.popular(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testExternalIDsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/person/1/external_ids"))

        let url = PeopleEndpoint.externalIDs(personID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

}
