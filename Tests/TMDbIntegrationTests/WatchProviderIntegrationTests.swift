import TMDb
 import XCTest

 final class WatchProviderIntegrationTests: XCTestCase {

     var watchProviderService: WatchProviderService!

     override func setUp() {
         super.setUp()
         TMDb.configure(TMDbConfiguration(apiKey: tmdbAPIKey))
         watchProviderService = WatchProviderService()
     }

     override func tearDown() {
         watchProviderService = nil
         super.tearDown()
     }

    func testCountries() async throws {
        let countries = try await watchProviderService.countries()

        XCTAssertFalse(countries.isEmpty)
    }

    func testMovieWatchProviders() async throws {
        let watchProviders = try await watchProviderService.movieWatchProviders()

        XCTAssertFalse(watchProviders.isEmpty)
    }

    func testTVShowWatchProviders() async throws {
        let watchProviders = try await watchProviderService.tvShowWatchProviders()

        XCTAssertFalse(watchProviders.isEmpty)
    }

 }
