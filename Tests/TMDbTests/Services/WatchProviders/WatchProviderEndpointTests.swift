@testable import TMDb
import XCTest

final class WatchProviderEndpointTests: XCTestCase {

    func testRegionsEndpointReturnsURL() {
        let expectedURL = URL(string: "/watch/providers/regions")!

        let url = WatchProviderEndpoint.regions.path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieEndpointReturnsURL() {
        let regionCode = Locale.current.regionCode ?? ""
        let expectedURL = URL(string: "/watch/providers/movie?watch_region=\(regionCode)")!

        let url = WatchProviderEndpoint.movie.path

        XCTAssertEqual(url, expectedURL)
    }

}
