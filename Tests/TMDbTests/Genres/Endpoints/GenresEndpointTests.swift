@testable import TMDb
import XCTest

final class GenresEndpointTests: XCTestCase {

    func testMovieEndpointReturnsURL() {
        let expectedURL = URL(string: "/genre/movie/list")!

        let url = GenresEndpoint.movie.path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowEndpointReturnsURL() {
        let expectedURL = URL(string: "/genre/tv/list")!

        let url = GenresEndpoint.tvShow.path

        XCTAssertEqual(url, expectedURL)
    }

}
