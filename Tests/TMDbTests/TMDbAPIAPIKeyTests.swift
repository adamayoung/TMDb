import Combine
@testable import TMDb
import XCTest

class TMDbAPIAPIKeyTests: TMDbAPITestCase {

    func testSetAPIKeySetsAPIKeyOnAPIClient() {
        let expectedAPIKey = UUID().uuidString

        TMDbAPI.setAPIKey(expectedAPIKey)

        XCTAssertEqual(TMDbAPIClient.shared.apiKey, expectedAPIKey)

        TMDbAPIClient.setAPIKey("")
    }

}
