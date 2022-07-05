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

        await withThrowingTaskGroup(of: APIConfiguration.self) { group in
            for _ in 0...10 {
                group.addTask {
                    try await self.service.apiConfiguration()
                }
            }
        }

        XCTAssertEqual(apiClient.getCount, 1)
    }

    func testCountriesReturnsCountries() async throws {
        let expectedResult = Country.mocks
        apiClient.result = .success(expectedResult)

        let result = try await service.countries()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, ConfigurationEndpoint.countries.path)
    }

}
