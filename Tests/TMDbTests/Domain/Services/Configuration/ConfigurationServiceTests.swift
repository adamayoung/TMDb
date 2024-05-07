//
//  ConfigurationServiceTests.swift
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

@testable import TMDb
import XCTest

final class ConfigurationServiceTests: XCTestCase {

    var service: ConfigurationService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = ConfigurationService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testAPIConfigurationReturnsAPIConfiguration() async throws {
        let expectedResult = APIConfiguration.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = APIConfigurationRequest()

        let result = try await service.apiConfiguration()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? APIConfigurationRequest, expectedRequest)
    }

    func testCountriesReturnsCountries() async throws {
        let expectedResult = [Country].mocks
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CountriesConfigurationRequest(language: nil)

        let result = try await service.countries()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? CountriesConfigurationRequest, expectedRequest)
    }

    func testJobsByDepartmentReturnsDepartments() async throws {
        let expectedResult = [Department].mocks
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = JobsConfigurationRequest()

        let result = try await service.jobsByDepartment()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? JobsConfigurationRequest, expectedRequest)
    }

    func testLanguagesReturnsLanguages() async throws {
        let expectedResult = [Language].mocks
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = LanguaguesConfigurationRequest()

        let result = try await service.languages()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? LanguaguesConfigurationRequest, expectedRequest)
    }

}
