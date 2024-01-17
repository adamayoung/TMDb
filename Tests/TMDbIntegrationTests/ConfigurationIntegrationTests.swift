//
//  ConfigurationIntegrationTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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

import TMDb
import XCTest

final class ConfigurationIntegrationTests: XCTestCase {

    var configurationService: ConfigurationService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
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
