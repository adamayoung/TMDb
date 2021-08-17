@testable import TMDb
import XCTest

final class ConfigurationEndpointTests: XCTestCase {

    func testAPIEndpointReturnsURL() {
        let expectedURL = URL(string: "/configuration")!

        let url = ConfigurationEndpoint.api.url

        XCTAssertEqual(url, expectedURL)
    }

}
