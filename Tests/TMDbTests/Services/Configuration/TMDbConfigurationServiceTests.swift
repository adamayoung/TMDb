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
        XCTAssertEqual(apiClient.lastPath, ConfigurationEndpoint.api.path)
    }

    func testAPIConfigurationWhenCalledMultipleTimesMakesOneRequest() async throws {
        let expectedResult = APIConfiguration.mock
        apiClient.result = .success(expectedResult)
        apiClient.requestTime = 0.5

        Task.detached { [unowned self] in
            _ = try await service.apiConfiguration()
        }

        Task.detached { [unowned self] in
            _ = try await service.apiConfiguration()
        }

        Task.detached { [unowned self] in
            _ = try await service.apiConfiguration()
        }

        let expectation = self.expectation(description: "apiConfiguration")

        Task.detached { [unowned self] in
            Thread.sleep(forTimeInterval: 1)

            let result = try? await service.apiConfiguration()

            XCTAssertEqual(result, expectedResult)
            expectation.fulfill()
        }

        await waitForExpectations(timeout: 2)

        XCTAssertEqual(apiClient.getCount, 1)
    }

}
