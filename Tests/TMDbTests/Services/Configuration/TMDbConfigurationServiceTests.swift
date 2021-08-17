@testable import TMDb
import XCTest

final class TMDbConfigurationServiceTests: XCTestCase {

    var service: TMDbConfigurationService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbConfigurationService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testFetchAPIConfigurationReturnsAPIConfiguration() {
        let expectedResult = APIConfiguration.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchAPIConfiguration { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, ConfigurationEndpoint.api.url)
    }

}
