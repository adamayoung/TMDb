@testable import TMDb
import XCTest

final class GenresEndpointTests: XCTestCase {

    func testMoviesEndpointReturnsURL() {
        let expectedURL = URL(string: "/genre/movie/list")!

        let url = GenresEndpoint.movies.path

        XCTAssertEqual(url, expectedURL)
    }

}
