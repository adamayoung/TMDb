@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

class TMDbConfigurationServiceTests: XCTestCase {

    #if canImport(Combine)
    var cancellables: Set<AnyCancellable> = []
    #endif
    var service: TMDbConfigurationService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbConfigurationService(apiClient: apiClient)
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

#if canImport(Combine)
extension TMDbConfigurationServiceTests {

    func testAPIConfigurationPublisherReturnsAPIConfiguration() throws {
        let expectedResult = APIConfiguration.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.apiConfigurationPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, ConfigurationEndpoint.api.url)
    }

}
#endif
