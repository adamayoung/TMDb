@testable import TMDb
import XCTest

class PeopleEndpointTests: XCTestCase {

    func testPersonDetailsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/person/1")!

        let url = PeopleEndpoint.details(personID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonCombinedCreditsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/person/1/combined_credits")!

        let url = PeopleEndpoint.combinedCredits(personID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonMovieCreditsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/person/1/movie_credits")!

        let url = PeopleEndpoint.movieCredits(personID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonTVShowCreditsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/person/1/tv_credits")!

        let url = PeopleEndpoint.tvShowCredits(personID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonImagesEndpoint_returnsURL() {
        let expectedURL = URL(string: "/person/1/images")!

        let url = PeopleEndpoint.images(personID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testPopularPeopleEndpoint_returnsURL() {
        let expectedURL = URL(string: "/person/popular")!

        let url = PeopleEndpoint.popular().url

        XCTAssertEqual(url, expectedURL)
    }

    func testPopularPeopleEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/person/popular?page=1")!

        let url = PeopleEndpoint.popular(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

}
