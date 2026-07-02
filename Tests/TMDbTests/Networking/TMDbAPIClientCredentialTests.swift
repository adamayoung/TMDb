//
//  TMDbAPIClientCredentialTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.networking))
struct TMDbAPIClientCredentialTests {

    var baseURL: URL!
    var serialiser: TMDbJSONSerialiser!
    var httpClient: HTTPMockClient!

    init() async {
        self.baseURL = URL(string: "https://some.domain.com/path")
        self.serialiser = TMDbJSONSerialiser()
        self.httpClient = await HTTPMockClient()
    }

    private func apiClient(credential: APICredential) -> TMDbAPIClient {
        TMDbAPIClient(
            credential: credential,
            baseURL: baseURL,
            serialiser: serialiser,
            httpClient: httpClient
        )
    }

    @Test("an API key credential sends api_key and no Authorization header")
    @MainActor
    func apiKeyCredentialSendsAPIKeyQueryItem() async throws {
        let client = apiClient(credential: .apiKey("abc123"))
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        httpClient.result = .success(HTTPResponse())

        _ = try? await client.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)
        let components = try #require(URLComponents(url: request.url, resolvingAgainstBaseURL: false))
        let apiKeyItem = components.queryItems?.first { $0.name == "api_key" }
        #expect(apiKeyItem?.value == "abc123")
        #expect(request.headers["Authorization"] == nil)
    }

    @Test("a bearer token credential sends an Authorization header and no api_key")
    @MainActor
    func bearerTokenCredentialSendsAuthorizationHeader() async throws {
        let client = apiClient(credential: .bearerToken("v4-access-token"))
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        httpClient.result = .success(HTTPResponse())

        _ = try? await client.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)
        #expect(request.headers["Authorization"] == "Bearer v4-access-token")
        let components = try #require(URLComponents(url: request.url, resolvingAgainstBaseURL: false))
        let hasAPIKey = components.queryItems?.contains { $0.name == "api_key" } ?? false
        #expect(hasAPIKey == false)
    }

}
