@testable import TMDb
import XCTest

class ConfigurationEndpointTests: XCTestCase {

    func testAPIEndpoint_returnsURL() {
        let expectedURL = URL(string: "/configuration")!

        let url = ConfigurationEndpoint.api.url

        XCTAssertEqual(url, expectedURL)
    }

}
