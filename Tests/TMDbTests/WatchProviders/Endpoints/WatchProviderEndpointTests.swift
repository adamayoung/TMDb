@testable import TMDb
import XCTest

final class WatchProviderEndpointTests: XCTestCase {

    func testRegionsEndpointReturnsURL() {
        let expectedURL = URL(string: "/watch/providers/regions")!

        let url = WatchProviderEndpoint.regions.path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieEndpointReturnsURL() {
        let regionCode = "GB"
        let expectedURL = URL(string: "/watch/providers/movie?watch_region=\(regionCode)")!

        let url = WatchProviderEndpoint.movie.path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowEndpointReturnsURL() {
        let regionCode = "GB"
        let expectedURL = URL(string: "/watch/providers/tv?watch_region=\(regionCode)")!

        let url = WatchProviderEndpoint.tvShow.path

        XCTAssertEqual(url, expectedURL)
    }

}
