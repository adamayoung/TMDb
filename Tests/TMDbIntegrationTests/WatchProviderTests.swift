@testable import TMDb
import XCTest

final class WatchProviderTests: XCTestCase {

    private var tmdb: TMDbAPI!

    override func setUpWithError() throws {
        super.setUp()
        tmdb = TMDbAPI(apiKey: "", urlSessionConfiguration: .integrationTest)
    }

    override func tearDown() {
        tmdb = nil
        TMDbURLProtocol.reset()
        super.tearDown()
    }

    func testCountries() async throws {
        TMDbURLProtocol.add("watch-providers-regions", for: WatchProviderEndpoint.regions)

        let countries = try await tmdb.watchProviders.countries()

        XCTAssertTrue(!countries.isEmpty)
    }

}
