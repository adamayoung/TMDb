import TMDb
import XCTest

final class ConfigurationIntegrationTests: XCTestCase {

    var configurationService: ConfigurationService!

    override func setUp() {
        super.setUp()
        TMDb.configure(TMDbConfiguration(apiKey: tmdbAPIKey))
        configurationService = ConfigurationService()
    }

    override func tearDown() {
        configurationService = nil
        super.tearDown()
    }

    func testAPIConfiguration() async throws {
        let configuration = try await configurationService.apiConfiguration()

        XCTAssertFalse(configuration.images.backdropSizes.isEmpty)
        XCTAssertFalse(configuration.images.logoSizes.isEmpty)
        XCTAssertFalse(configuration.images.posterSizes.isEmpty)
        XCTAssertFalse(configuration.images.profileSizes.isEmpty)
        XCTAssertFalse(configuration.images.stillSizes.isEmpty)
        XCTAssertFalse(configuration.changeKeys.isEmpty)
    }

    func testCountries() async throws {
        let countries = try await configurationService.countries()

        XCTAssertFalse(countries.isEmpty)
    }

    func testJobsByDepartment() async throws {
        let departments = try await configurationService.jobsByDepartment()

        XCTAssertFalse(departments.isEmpty)
    }

    func testLanguages() async throws {
        let languages = try await configurationService.languages()

        XCTAssertFalse(languages.isEmpty)
    }

}
