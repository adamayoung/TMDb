@testable import TMDb
import XCTest

final class ConfigurationTests: XCTestCase {

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

    func testAPIConfiguration() async throws {
        TMDbURLProtocol.add("configuration-api", for: ConfigurationEndpoint.api)

        let configuration = try await tmdb.configurations.apiConfiguration()

        XCTAssertTrue(!configuration.images.backdropSizes.isEmpty)
        XCTAssertTrue(!configuration.images.logoSizes.isEmpty)
        XCTAssertTrue(!configuration.images.posterSizes.isEmpty)
        XCTAssertTrue(!configuration.images.profileSizes.isEmpty)
        XCTAssertTrue(!configuration.images.stillSizes.isEmpty)
        XCTAssertTrue(!configuration.changeKeys.isEmpty)
    }

    func testCountries() async throws {
        TMDbURLProtocol.add("configuration-countries", for: ConfigurationEndpoint.countries)

        let countries = try await tmdb.configurations.countries()

        XCTAssertTrue(!countries.isEmpty)
    }

    func testJobsByDepartment() async throws {
        TMDbURLProtocol.add("configuration-jobs", for: ConfigurationEndpoint.jobs)

        let departments = try await tmdb.configurations.jobsByDepartment()

        XCTAssertTrue(!departments.isEmpty)
    }

    func testLanguages() async throws {
        TMDbURLProtocol.add("configuration-languages", for: ConfigurationEndpoint.languages)

        let languages = try await tmdb.configurations.languages()

        XCTAssertTrue(!languages.isEmpty)
    }

}
