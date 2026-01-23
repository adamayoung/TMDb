//
//  TMDbAPIClientTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

@Suite(.tags(.networking))
struct TMDbAPIClientTests {

    var apiClient: TMDbAPIClient!
    var apiKey: String!
    var baseURL: URL!
    var serialiser: TMDbJSONSerialiser!
    var httpClient: HTTPMockClient!

    init() async {
        self.apiKey = "abc123"
        self.baseURL = URL(string: "https://some.domain.com/path")
        self.serialiser = TMDbJSONSerialiser()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        self.httpClient = await HTTPMockClient()
        self.apiClient = TMDbAPIClient(
            apiKey: apiKey,
            baseURL: baseURL,
            serialiser: serialiser,
            httpClient: httpClient
        )
    }

    @Test("perform when invalid path throws error")
    @MainActor
    func performWhenInvalidPathThrowsError() async throws {
        let path = ""
        let stubRequest = APIStubRequest<String, String>(path: path)
        httpClient.result = .success(HTTPResponse())

        var error: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let err {
            error = err as? TMDbAPIError
        }

        #if canImport(FoundationNetworking)
            #expect(error == .unknown)
        #else
            #expect(error == .invalidURL(path))
        #endif
    }

    @Test("perform has correct URL")
    @MainActor
    func performHasCorrectURL() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        let expectedURL = try #require(URL(string: "https://some.domain.com/path/endpoint"))
        httpClient.result = .success(HTTPResponse())

        _ = try? await apiClient.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)

        #expect(request.url.absoluteString.starts(with: expectedURL.absoluteString))
    }

    @Test("perform when GET method")
    @MainActor
    func performWhenGetMethod() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint", method: .get)
        httpClient.result = .success(HTTPResponse())

        _ = try? await apiClient.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)

        #expect(request.method == .get)
    }

    @Test("perform when POST method")
    @MainActor
    func performWhenPostMethod() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint", method: .post)
        httpClient.result = .success(HTTPResponse())

        _ = try? await apiClient.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)

        #expect(request.method == .post)
    }

    @Test("perfom when DELETE method")
    @MainActor
    func performWhenDeleteMethod() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint", method: .delete)
        httpClient.result = .success(HTTPResponse())

        _ = try? await apiClient.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)

        #expect(request.method == .delete)
    }

}
