//
//  TMDbAPIClientTests.swift
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
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

final class TMDbAPIClientTests: XCTestCase {

    var apiClient: TMDbAPIClient!
    var apiKey: String!
    var baseURL: URL!
    var serialiser: TMDbJSONSerialiser!
    var httpClient: HTTPMockClient!
    var localeProvider: LocaleMockProvider!

    override func setUp() async throws {
        try await super.setUp()
        apiKey = "abc123"
        baseURL = try XCTUnwrap(URL(string: "https://some.domain.com/path"))
        serialiser = TMDbJSONSerialiser()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        httpClient = await HTTPMockClient()
        localeProvider = LocaleMockProvider(languageCode: "en", regionCode: "GB")
        apiClient = TMDbAPIClient(
            apiKey: apiKey,
            baseURL: baseURL,
            serialiser: serialiser,
            httpClient: httpClient,
            localeProvider: localeProvider
        )
    }

    override func tearDown() async throws {
        apiClient = nil
        localeProvider = nil
        httpClient = nil
        serialiser = nil
        baseURL = nil
        apiKey = nil
        try await super.tearDown()
    }

    @MainActor
    func testPerformWhenInvalidPathThrowsError() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "")
        httpClient.result = .success(HTTPResponse())

        var error: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let err {
            error = err as? TMDbAPIError
        }

        switch error {
        case let .invalidURL(path):
            XCTAssertEqual(path, "")

        default:
            XCTFail("Unexpected error")
        }
    }

    @MainActor
    func testPerformHasCorrectURL() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        let expectedURL = try XCTUnwrap(URL(string: "https://some.domain.com/path/endpoint"))
        httpClient.result = .success(HTTPResponse())

        _ = try? await apiClient.perform(stubRequest)

        let request = try XCTUnwrap(httpClient.lastRequest)

        XCTAssertTrue(request.url.absoluteString.starts(with: expectedURL.absoluteString))
    }

    @MainActor
    func testPerformWhenGetMethod() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint", method: .get)
        httpClient.result = .success(HTTPResponse())

        _ = try? await apiClient.perform(stubRequest)

        let request = try XCTUnwrap(httpClient.lastRequest)

        XCTAssertEqual(request.method, .get)
    }

    @MainActor
    func testPerformWhenPostMethod() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint", method: .post)
        httpClient.result = .success(HTTPResponse())

        _ = try? await apiClient.perform(stubRequest)

        let request = try XCTUnwrap(httpClient.lastRequest)

        XCTAssertEqual(request.method, .post)
    }

    @MainActor
    func testPerformWhenDeleteMethod() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint", method: .delete)
        httpClient.result = .success(HTTPResponse())

        _ = try? await apiClient.perform(stubRequest)

        let request = try XCTUnwrap(httpClient.lastRequest)

        XCTAssertEqual(request.method, .delete)
    }

}

extension TMDbAPIClientTests {

    private struct MockObject: Codable, Equatable {

        let id: UUID

        var data: Data {
            // swiftlint:disable force_try
            try! JSONEncoder().encode(self)
            // swiftlint:enable force_try
        }

        init(id: UUID = .init()) {
            self.id = id
        }
    }

}
