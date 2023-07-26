@testable import TMDb
import XCTest

final class WatchProviderServiceTests: XCTestCase {

    var service: WatchProviderService!
    var apiClient: MockAPIClient!
    var locale: Locale!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        locale = Locale(identifier: "en_GB")
        service = WatchProviderService(apiClient: apiClient, localeProvider: { [unowned self] in self.locale })
    }

    override func tearDown() {
        apiClient = nil
        locale = nil
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

    func testMovieWatchProvidersReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let expectedResult = watchProviderResult.results
        apiClient.result = .success(watchProviderResult)

        let result = try await service.movieWatchProviders()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, WatchProviderEndpoint.movie(regionCode: locale.regionCode).path)
    }

    func testTVShowWatchProvidersReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let expectedResult = watchProviderResult.results
        apiClient.result = .success(watchProviderResult)

        let result = try await service.tvShowWatchProviders()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, WatchProviderEndpoint.tvShow(regionCode: locale.regionCode).path)
    }

}
