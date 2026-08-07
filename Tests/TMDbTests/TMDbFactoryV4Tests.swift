//
//  TMDbFactoryV4Tests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

///
/// Pins the v4 client to the v4 base URL.
///
/// Every service unit test drives a `MockAPIClient` and so never sees a URL,
/// which means a wrong base URL — or wiring `apiClient` where `v4APIClient`
/// was meant — would pass the entire unit suite. These tests are the only
/// thing that would catch it.
///
@Suite(.tags(.networking, .authentication))
struct TMDbFactoryV4Tests {

    var httpClient: HTTPMockClient!

    init() async {
        self.httpClient = await HTTPMockClient()
    }

    @Test("the v4 API client targets the v4 base URL")
    @MainActor
    func v4APIClientTargetsV4BaseURL() async throws {
        let client = TMDbFactory.v4APIClient(
            credential: .bearerToken("token"),
            httpClient: httpClient
        )
        let stubRequest = APIStubRequest<String, String>(path: "/auth/request_token")
        httpClient.result = .success(HTTPResponse())

        _ = try? await client.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)
        #expect(request.url.host == "api.themoviedb.org")
        #expect(request.url.path == "/4/auth/request_token")
    }

    @Test("the v3 API client is unaffected and still targets the v3 base URL")
    @MainActor
    func v3APIClientStillTargetsV3BaseURL() async throws {
        let client = TMDbFactory.apiClient(
            credential: .bearerToken("token"),
            httpClient: httpClient
        )
        let stubRequest = APIStubRequest<String, String>(path: "/movie/550")
        httpClient.result = .success(HTTPResponse())

        _ = try? await client.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)
        #expect(request.url.path == "/3/movie/550")
    }

}
