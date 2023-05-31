@testable import TMDb
import XCTest

final class ConfigurationEndpointTests: XCTestCase {

    func testAPIEndpointReturnsURL() {
        let expectedURL = URL(string: "/configuration")!

        let url = ConfigurationEndpoint.api.path

        XCTAssertEqual(url, expectedURL)
    }

    func testCountriesEndpointReturnsURL() {
        let expectedURL = URL(string: "/configuration/countries")!

        let url = ConfigurationEndpoint.countries.path

        XCTAssertEqual(url, expectedURL)
    }

    func testJobsEndpointReturnsURL() {
        let expectedURL = URL(string: "/configuration/jobs")!

        let url = ConfigurationEndpoint.jobs.path

        XCTAssertEqual(url, expectedURL)
    }

    func testLanguageEndpointReturnsURL() {
        let expectedURL = URL(string: "/configuration/languages")!

        let url = ConfigurationEndpoint.languages.path

        XCTAssertEqual(url, expectedURL)
    }

}
