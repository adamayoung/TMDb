//
//  URLSessionHTTPClientAdapterTests.swift
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

import Foundation
import Testing

@testable import TMDb

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

private let isLinux = {
    #if os(Linux)
        return true
    #else
        return false
    #endif
}()

@Suite(
    .serialized,
    .tags(.adapter),
    .disabled(if: isLinux)
)
final class URLSessionHTTPClientAdapterTests {

    var httpClient: URLSessionHTTPClientAdapter!
    var baseURL: URL!
    var urlSession: URLSession!

    init() throws {
        self.baseURL = try #require(URL(string: "https://some.domain.com/path"))

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        self.urlSession = URLSession(configuration: configuration)
        self.httpClient = URLSessionHTTPClientAdapter(urlSession: urlSession)
    }

    deinit {
        httpClient = nil
        urlSession = nil
        baseURL = nil
        Task {
            await MockURLProtocol.reset()
        }
    }

    @Test("perform when response status code is 401 returns unauthorised error")
    @MainActor
    func performWhenResponseStatusCodeIs401ReturnsUnauthorisedError() async throws {
        MockURLProtocol.responseStatusCode = 401
        let url = try #require(URL(string: "/error"))
        let request = HTTPRequest(url: url)

        let response = try await httpClient.perform(request: request)

        #expect(response.statusCode == 401)
    }

    @Test("perform when response status code is 404 returns not found error")
    @MainActor
    func performWhenResponseStatusCodeIs404ReturnsNotFoundError() async throws {
        MockURLProtocol.responseStatusCode = 404
        let url = try #require(URL(string: "/error"))
        let request = HTTPRequest(url: url)

        let response = try await httpClient.perform(request: request)

        #expect(response.statusCode == 404)
    }

    @Test(
        "perform when response status code is 404 and has status message error throws not found error with message"
    )
    @MainActor
    func performWhenResponseStatusCodeIs404AndHasStatusMessageErrorThrowsNotFoundErrorWithMessage()
        async throws
    {
        MockURLProtocol.responseStatusCode = 404
        let expectedData = try Data(fromResource: "error-status-response", withExtension: "json")
        MockURLProtocol.data = expectedData
        let url = try #require(URL(string: "/error"))
        let request = HTTPRequest(url: url)

        let response = try await httpClient.perform(request: request)

        #expect(response.statusCode == 404)
        #expect(response.data == expectedData)
    }

    @Test("perform when response has valid data returns decoded object")
    @MainActor
    func performWhenResponseHasValidDataReturnsDecodedObject() async throws {
        let expectedStatusCode = 200
        let expectedData = Data("abc".utf8)
        MockURLProtocol.data = expectedData
        let url = try #require(URL(string: "/object"))
        let request = HTTPRequest(url: url)

        let response = try await httpClient.perform(request: request)

        #expect(response.statusCode == expectedStatusCode)
        #expect(response.data == expectedData)
    }

    @Test("perform URL request has correct URL")
    @MainActor
    func performURLRequestHasCorrectURL() async throws {
        let path = "/object?key1=value1&key2=value2"
        let expectedURL = try #require(URL(string: path))
        let request = HTTPRequest(url: expectedURL)

        _ = try? await httpClient.perform(request: request)

        let result = MockURLProtocol.lastRequest?.url

        #expect(result == expectedURL)
    }

    @Test("perform when header set should be present in URL request")
    @MainActor
    func performWhenHeaderSetShouldBePresentInURLRequest() async throws {
        let url = try #require(URL(string: "/object"))
        let header1Name = "Accept"
        let header1Value = "application/json"
        let header2Name = "Content-Type"
        let header2Value = "text/html"
        let headers = [
            header1Name: header1Value,
            header2Name: header2Value
        ]
        let request = HTTPRequest(url: url, headers: headers)

        _ = try? await httpClient.perform(request: request)

        let lastURLRequest = try #require(MockURLProtocol.lastRequest)
        let result1 = lastURLRequest.value(forHTTPHeaderField: header1Name)
        let result2 = lastURLRequest.value(forHTTPHeaderField: header2Name)

        #expect(result1 == header1Value)
        #expect(result2 == header2Value)
    }

}
