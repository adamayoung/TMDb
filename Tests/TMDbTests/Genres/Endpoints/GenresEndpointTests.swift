@testable import TMDb
import XCTest

final class GenresEndpointTests: XCTestCase {

    func testMovieEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/genre/movie/list"))

        let url = GenresEndpoint.movie.path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/genre/tv/list"))

        let url = GenresEndpoint.tvShow.path

        XCTAssertEqual(url, expectedURL)
    }

}
