@testable import TMDb
import XCTest

class TMDbAPIClientTests: XCTestCase {

    var apiClient: TMDbAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = TMDbAPIClient()
    }

    func testSetAPIKey() {
        let expectedResult = "abc123"

        apiClient.setAPIKey(expectedResult)

        XCTAssertEqual(apiClient.apiKey, expectedResult)
    }

    func testStaticSetAPIKey() {
        let expectedResult = "abc123"

        TMDbAPIClient.setAPIKey(expectedResult)

        XCTAssertEqual(TMDbAPIClient.shared.apiKey, expectedResult)
    }

}
