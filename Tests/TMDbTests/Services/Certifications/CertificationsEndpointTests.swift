@testable import TMDb
import XCTest

class CertificationsEndpointTests: XCTestCase {

    func testMovieEndpoint_returnsURL() {
        let expectedURL = URL(string: "/certification/movie/list")!

        let url = CertificationsEndpoint.movie.url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowEndpoint_returnsURL() {
        let expectedURL = URL(string: "/certification/tv/list")!

        let url = CertificationsEndpoint.tvShow.url

        XCTAssertEqual(url, expectedURL)
    }

}
