#if canImport(Combine)
import Combine
@testable import TMDb
import XCTest

class TMDbConfigurationServiceCombineTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
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

    func testAPIConfigurationPublisherReturnsAPIConfiguration() throws {
        let expectedResult = APIConfiguration.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.apiConfigurationPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, ConfigurationEndpoint.api.url)
    }

}
#endif
