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
    var httpClient: HTTPMockClient!
    var serialiser: Serialiser!
    var localeProvider: LocaleMockProvider!

    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        apiKey = "abc123"
        baseURL = try XCTUnwrap(URL(string: "https://some.domain.com/path"))

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        httpClient = HTTPMockClient()
        serialiser = TMDbJSONSerialiser()
        localeProvider = LocaleMockProvider(languageCode: "en", regionCode: "GB")
        apiClient = TMDbAPIClient(
            apiKey: apiKey,
            baseURL: baseURL,
            httpClient: httpClient,
            serialiser: serialiser,
            localeProvider: localeProvider
        )
    }

    override func tearDown() async throws {
        apiClient = nil
        localeProvider = nil
        serialiser = nil
        httpClient = nil
        baseURL = nil
        apiKey = nil
        try await super.tearDown()
    }

    @MainActor
    func testGetWhenResponseStatusCodeIs401ReturnsUnauthorisedError() async throws {
        httpClient.result = .success(HTTPResponse(statusCode: 401))

        do {
            _ = try await apiClient.get(path: URL(string: "/error")!) as String
        } catch let error as TMDbAPIError {
            switch error {
            case .unauthorised:
                XCTAssertTrue(true)
                return
            default:
                break
            }
        }

        XCTFail("Expected unauthorised error to be thrown")
    }

    @MainActor
    func testGetWhenResponseStatusCodeIs404ReturnsNotFoundError() async throws {
        httpClient.result = .success(HTTPResponse(statusCode: 404))

        do {
            _ = try await apiClient.get(path: URL(string: "/error")!) as String
        } catch let error as TMDbAPIError {
            switch error {
            case .notFound:
                XCTAssertTrue(true)
                return
            default:
                break
            }
        }

        XCTFail("Expected not found error to be thrown")
    }

    @MainActor
    func testGetWhenResponseStatusCodeIs404AndHasStatusMessageErrorThrowsNotFoundErrorWithMessage() async throws {
        let expectedStatusMessage = "The resource you requested could not be found."
        let statusResponse = try Data(fromResource: "error-status-response", withExtension: "json")
        httpClient.result = .success(HTTPResponse(statusCode: 404, data: statusResponse))

        do {
            _ = try await apiClient.get(path: URL(string: "/error")!) as String
        } catch let error as TMDbAPIError {
            switch error {
            case let .notFound(message):
                XCTAssertEqual(message, expectedStatusMessage)
                return

            default:
                break
            }
        }

        XCTFail("Expected unknown error to be thrown")
    }

    @MainActor
    func testGetWhenResponseHasValidDataReturnsDecodedObject() async throws {
        let expectedResult = MockObject()
        httpClient.result = .success(HTTPResponse(data: expectedResult.data))

        let result: MockObject = try await apiClient.get(path: URL(string: "/object")!)

        XCTAssertEqual(result, expectedResult)
    }

    @MainActor
    func testGetURLRequestAcceptHeaderSetToApplicationJSON() async throws {
        httpClient.result = .success(HTTPResponse())
        let expectedResult = "application/json"

        _ = try? await apiClient.get(path: URL(string: "/object")!) as String

        let result = httpClient.lastRequest?.headers["Accept"]

        XCTAssertEqual(result, expectedResult)
    }

    @MainActor
    func testGetURLRequestHasCorrectURL() async throws {
        httpClient.result = .success(HTTPResponse())
        let path = "/object"
        let language = "en"
        let urlString = "\(baseURL.absoluteURL)\(path)?api_key=\(apiKey!)&language=\(language)"
        let expectedResult = try XCTUnwrap(URL(string: urlString))

        _ = try? await apiClient.get(path: URL(string: path)!) as String

        let result = httpClient.lastRequest?.url

        XCTAssertEqual(result, expectedResult)
    }

    @MainActor
    func testPostURLRequestAcceptHeaderSetToApplicationJSON() async throws {
        httpClient.result = .success(HTTPResponse())
        let expectedResult = "application/json"
        let pathURL = try XCTUnwrap(URL(string: "/object"))

        _ = try? await apiClient.post(path: pathURL, body: "adam") as String

        let result = httpClient.lastRequest?.headers["Accept"]

        XCTAssertEqual(result, expectedResult)
    }

    @MainActor
    func testPostURLRequestContentTypeHeaderSetToApplicationJSON() async throws {
        httpClient.result = .success(HTTPResponse())
        let expectedResult = "application/json"
        let pathURL = try XCTUnwrap(URL(string: "/object"))

        _ = try? await apiClient.post(path: pathURL, body: "adam") as String

        let result = httpClient.lastRequest?.headers["Content-Type"]

        XCTAssertEqual(result, expectedResult)
    }

    @MainActor
    func testPostURLRequestHasCorrectURL() async throws {
        httpClient.result = .success(HTTPResponse())
        let path = "/object"
        let pathURL = try XCTUnwrap(URL(string: path))
        let language = "en"
        let urlString = "\(baseURL.absoluteURL)\(path)?api_key=\(apiKey!)&language=\(language)"
        let expectedResult = try XCTUnwrap(URL(string: urlString))

        _ = try? await apiClient.post(path: pathURL, body: "adam") as String

        let result = httpClient.lastRequest?.url

        XCTAssertEqual(result, expectedResult)
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
