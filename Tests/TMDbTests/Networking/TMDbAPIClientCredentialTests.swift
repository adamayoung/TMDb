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

    // MARK: - Per-call credential precedence

    @Test("a request's own Authorization header wins over the client's bearer token")
    @MainActor
    func requestAuthorizationWinsOverBearerCredential() async throws {
        let client = apiClient(credential: .bearerToken("application-token"))
        let stubRequest = APIStubRequest<String, String>(
            path: "/endpoint",
            headers: ["Authorization": "Bearer user-token"]
        )
        httpClient.result = .success(HTTPResponse())

        _ = try? await client.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)
        #expect(request.headers["Authorization"] == "Bearer user-token")
    }

    @Test("a request's own Authorization header suppresses the client's api_key query item")
    @MainActor
    func requestAuthorizationSuppressesAPIKey() async throws {
        // Sending both credentials would leave precedence to the server, which
        // was never probed — so the client credential is withheld entirely.
        let client = apiClient(credential: .apiKey("abc123"))
        let stubRequest = APIStubRequest<String, String>(
            path: "/endpoint",
            headers: ["Authorization": "Bearer user-token"]
        )
        httpClient.result = .success(HTTPResponse())

        _ = try? await client.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)
        #expect(request.headers["Authorization"] == "Bearer user-token")
        let components = try #require(URLComponents(url: request.url, resolvingAgainstBaseURL: false))
        let hasAPIKey = components.queryItems?.contains { $0.name == "api_key" } ?? false
        #expect(hasAPIKey == false)
    }

    // MARK: - isUserSpecific

    @Test("isUserSpecific is set when the request carries its own Authorization")
    @MainActor
    func isUserSpecificSetForPerCallCredential() async throws {
        let client = apiClient(credential: .bearerToken("application-token"))
        let stubRequest = APIStubRequest<String, String>(
            path: "/endpoint",
            headers: ["Authorization": "Bearer user-token"]
        )
        httpClient.result = .success(HTTPResponse())

        _ = try? await client.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)
        #expect(request.isUserSpecific)
    }

    @Test("isUserSpecific is set for a v3 session request")
    @MainActor
    func isUserSpecificSetForSessionRequest() async throws {
        // A v3 session request is user-scoped too. Its `session_id` is in the
        // URL, so the on-disk cache keys differ per user and nothing leaks
        // across users — but the response is still private data being written
        // to a shared cache that survives relaunch.
        let client = apiClient(credential: .apiKey("abc123"))
        let stubRequest = APIStubRequest<String, String>(
            path: "/account/42/lists",
            queryItems: ["session_id": "user-session"]
        )
        httpClient.result = .success(HTTPResponse())

        _ = try? await client.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)
        #expect(request.isUserSpecific)
    }

    @Test("isUserSpecific is set for a guest session request")
    @MainActor
    func isUserSpecificSetForGuestSessionRequest() async throws {
        let client = apiClient(credential: .apiKey("abc123"))
        let stubRequest = APIStubRequest<String, String>(
            path: "/guest_session/abc/rated/movies"
        )
        httpClient.result = .success(HTTPResponse())

        _ = try? await client.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)
        #expect(request.isUserSpecific)
    }

    @Test("isUserSpecific is not set for an ordinary api_key request")
    @MainActor
    func isUserSpecificNotSetForAPIKeyRequest() async throws {
        let client = apiClient(credential: .apiKey("abc123"))
        let stubRequest = APIStubRequest<String, String>(path: "/movie/550")
        httpClient.result = .success(HTTPResponse())

        _ = try? await client.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)
        #expect(request.isUserSpecific == false)
    }

    @Test("isUserSpecific is not set when only the client credential authenticates")
    @MainActor
    func isUserSpecificNotSetForClientCredential() async throws {
        // A bearer-token client puts an Authorization header on *every* request,
        // so the header alone cannot mean "user-specific" — otherwise caching
        // would be disabled wholesale for those clients.
        let client = apiClient(credential: .bearerToken("application-token"))
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        httpClient.result = .success(HTTPResponse())

        _ = try? await client.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)
        #expect(request.headers["Authorization"] == "Bearer application-token")
        #expect(request.isUserSpecific == false)
    }

}
