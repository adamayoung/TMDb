@testable import TMDb
import XCTest

final class PeopleEndpointTests: XCTestCase {

    func testPersonDetailsEndpointReturnsURL() {
        let expectedURL = URL(string: "/person/1")!

        let url = PeopleEndpoint.details(personID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonCombinedCreditsEndpointReturnsURL() {
        let expectedURL = URL(string: "/person/1/combined_credits")!

        let url = PeopleEndpoint.combinedCredits(personID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonMovieCreditsEndpointReturnsURL() {
        let expectedURL = URL(string: "/person/1/movie_credits")!

        let url = PeopleEndpoint.movieCredits(personID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonTVShowCreditsEndpointReturnsURL() {
        let expectedURL = URL(string: "/person/1/tv_credits")!

        let url = PeopleEndpoint.tvShowCredits(personID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testPersonImagesEndpointReturnsURL() {
        let expectedURL = URL(string: "/person/1/images")!

        let url = PeopleEndpoint.images(personID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testPopularPeopleEndpointReturnsURL() {
        let expectedURL = URL(string: "/person/popular")!

        let url = PeopleEndpoint.popular().url

        XCTAssertEqual(url, expectedURL)
    }

    func testPopularPeopleEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/person/popular?page=1")!

        let url = PeopleEndpoint.popular(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

}
