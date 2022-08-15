@testable import TMDb
import XCTest

final class WatchProviderEndpointTests: XCTestCase {

    func testRegionsEndpointReturnsURL() {
        let expectedURL = URL(string: "/watch/providers/regions")!

        let url = WatchProviderEndpoint.regions.path

        XCTAssertEqual(url, expectedURL)
    }

}
