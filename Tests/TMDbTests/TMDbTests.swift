//
//  TMDbTests.swift
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

final class TMDbTest: XCTestCase {

    func testConfigureSetsAPIKey() {
        let expectedAPIKey = "abc123"
        let configuration = TMDbConfiguration(apiKey: expectedAPIKey)

        TMDb.configure(configuration)
        let apiKey = TMDb.configuration.apiKey()

        XCTAssertEqual(apiKey, expectedAPIKey)
    }

    func testConfigurationWhenHTTPClientNotSetUsesDefaultAdapter() {
        let configuration = TMDbConfiguration(apiKey: "")

        TMDb.configure(configuration)
        let httpClient = TMDb.configuration.httpClient()

        XCTAssertTrue(httpClient is URLSessionHTTPClientAdapter)
    }

    func testConfigurationWhenSetsHTTPClient() {
        let expectedHTTPClient = MockHTTPClient()
        let configuration = TMDbConfiguration(apiKey: "", httpClient: expectedHTTPClient)

        TMDb.configure(configuration)
        let httpClient = TMDb.configuration.httpClient()

        XCTAssertIdentical(httpClient as AnyObject, expectedHTTPClient)
    }

}

extension TMDbTest {

    private final class MockHTTPClient: HTTPClient {

        init() {}

        func get(url _: URL, headers _: [String: String]) async throws -> HTTPResponse {
            HTTPResponse()
        }
    }

}
