@testable import TMDb
import XCTest

final class TMDbWatchProviderServiceTests: XCTestCase {

    var service: TMDbWatchProviderService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbWatchProviderService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testCountriesReturnsCountries() async throws {
        let regions = WatchProviderRegions.mock
        let expectedResult = regions.results
        apiClient.result = .success(regions)

        let result = try await service.countries()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, WatchProviderEndpoint.regions.path)
    }

}
