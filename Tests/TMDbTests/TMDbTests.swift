//
//  TMDbTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
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
