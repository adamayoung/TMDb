@testable import TMDb
import XCTest

final class ConfigurationServiceTests: XCTestCase {

    var service: ConfigurationService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = ConfigurationService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testAPIConfigurationReturnsAPIConfiguration() async throws {
        let expectedResult = APIConfiguration.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.apiConfiguration()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, ConfigurationEndpoint.api.path)
    }

    func testCountriesReturnsCountries() async throws {
        let expectedResult = [Country].mocks
        apiClient.result = .success(expectedResult)

        let result = try await service.countries()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, ConfigurationEndpoint.countries.path)
    }

    func testJobsByDepartmentReturnsDepartments() async throws {
        let expectedResult = [Department].mocks
        apiClient.result = .success(expectedResult)

        let result = try await service.jobsByDepartment()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, ConfigurationEndpoint.jobs.path)
    }

    func testLanguagesReturnsLanguages() async throws {
        let expectedResult = [Language].mocks
        apiClient.result = .success(expectedResult)

        let result = try await service.languages()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, ConfigurationEndpoint.languages.path)
    }

}
