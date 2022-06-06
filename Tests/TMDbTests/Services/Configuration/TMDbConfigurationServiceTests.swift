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

    func testAPIConfigurationReturnsAPIConfiguration() async throws {
        let expectedResult = APIConfiguration.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.apiConfiguration()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, ConfigurationEndpoint.api.url)
    }

}
