@testable import TMDb
import XCTest

final class CertificationsEndpointTests: XCTestCase {

    func testMovieEndpointReturnsURL() {
        let expectedURL = URL(string: "/certification/movie/list")!

        let url = CertificationsEndpoint.movie.path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowEndpointReturnsURL() {
        let expectedURL = URL(string: "/certification/tv/list")!

        let url = CertificationsEndpoint.tvShow.path

        XCTAssertEqual(url, expectedURL)
    }

}
