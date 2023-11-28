//
//  ConfigurationEndpointTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

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
