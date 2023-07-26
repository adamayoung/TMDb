@testable import TMDb
import XCTest

final class ConfigurationEndpointTests: XCTestCase {

    func testAPIEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/configuration"))

        let url = ConfigurationEndpoint.api.path

        XCTAssertEqual(url, expectedURL)
    }

    func testCountriesEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/configuration/countries"))

        let url = ConfigurationEndpoint.countries.path

        XCTAssertEqual(url, expectedURL)
    }

    func testJobsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/configuration/jobs"))

        let url = ConfigurationEndpoint.jobs.path

        XCTAssertEqual(url, expectedURL)
    }

    func testLanguageEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/configuration/languages"))

        let url = ConfigurationEndpoint.languages.path

        XCTAssertEqual(url, expectedURL)
    }

}
