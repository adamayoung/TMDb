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

    func testMovieWatchProvidersReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let expectedResult = watchProviderResult.results
        apiClient.result = .success(watchProviderResult)

        let result = try await service.movieWatchProviders()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, WatchProviderEndpoint.movie.path)
    }

    func testTVShowWatchProvidersReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let expectedResult = watchProviderResult.results
        apiClient.result = .success(watchProviderResult)

        let result = try await service.tvShowWatchProviders()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, WatchProviderEndpoint.tvShow.path)
    }

}
