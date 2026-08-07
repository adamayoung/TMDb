//
//  URLSessionHTTPClientAdapterTests.swift
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

@Suite(
    .serialized,
    .tags(.adapter)
)
final class URLSessionHTTPClientAdapterTests {

    var httpClient: URLSessionHTTPClientAdapter!
    var baseURL: URL!
    var urlSession: URLSession!

    init() {
        self.baseURL = URL(string: "https://some.domain.com/path")

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        self.urlSession = URLSession(configuration: configuration)
        self.httpClient = URLSessionHTTPClientAdapter(urlSession: urlSession)
    }

    deinit {
        httpClient = nil
        urlSession = nil
        baseURL = nil
        MockURLProtocol.reset()
    }

    @Test("perform when response status code is 401 returns unauthorised error")
    func performWhenResponseStatusCodeIs401ReturnsUnauthorisedError() async throws {
        MockURLProtocol.responseStatusCode = 401
        let url = try #require(URL(string: "/error"))
        let request = HTTPRequest(url: url)

        let response = try await httpClient.perform(request: request)

        #expect(response.statusCode == 401)
    }

    @Test("perform when response status code is 404 returns not found error")
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
    func performWhenResponseStatusCodeIs404AndHasStatusMessageErrorThrowsNotFoundErrorWithMessage()
    async throws {
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
    func performURLRequestHasCorrectURL() async throws {
        let path = "/object?key1=value1&key2=value2"
        let expectedURL = try #require(URL(string: path))
        let request = HTTPRequest(url: expectedURL)

        _ = try? await httpClient.perform(request: request)

        let result = MockURLProtocol.lastRequest?.url

        #expect(result == expectedURL)
    }

    @Test("perform when response has no data returns empty data")
    func performWhenResponseHasNoDataReturnsEmptyData() async throws {
        MockURLProtocol.data = nil
        MockURLProtocol.responseStatusCode = 204
        let url = try #require(URL(string: "/no-content"))
        let request = HTTPRequest(url: url)

        let response = try await httpClient.perform(request: request)

        #expect(response.statusCode == 204)
        #expect(response.data == Data())
    }

    @Test("perform when task is cancelled completes without hanging")
    func performWhenTaskIsCancelledCompletesWithoutHanging() async throws {
        MockURLProtocol.responseStatusCode = 200
        let url = try #require(URL(string: "/cancel"))
        let request = HTTPRequest(url: url)
        let client = try #require(httpClient)

        let task = Task {
            try await client.perform(request: request)
        }
        task.cancel()

        // The task should complete — either with a cancellation error
        // or a successful response if it finished before cancellation.
        _ = await task.result
    }

    @Test("perform when header set should be present in URL request")
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

    @Test("URLSessionHTTPClientAdapter conforms to Sendable")
    func conformsToSendable() {
        func requireSendable(_: (some Sendable).Type) {}

        // Compiles only while the adapter remains `Sendable`; guards against a
        // future change that would make it non-Sendable.
        requireSendable(URLSessionHTTPClientAdapter.self)
    }

    // MARK: - User-specific requests bypass the on-disk URLCache

    @Test("a user-specific request goes through a session with no URLCache")
    func userSpecificRequestUsesCacheFreeSession() throws {
        let url = try #require(URL(string: "https://api.themoviedb.org/4/list/1"))
        let request = HTTPRequest(url: url, isUserSpecific: true)

        let session = httpClient.session(for: request)

        #expect(session.configuration.urlCache == nil)
        #expect(session.configuration.requestCachePolicy == .reloadIgnoringLocalCacheData)
    }

    @Test("deriving the cache-free session leaves the injected session untouched")
    func derivingCacheFreeSessionDoesNotMutateInjectedSession() throws {
        // On Apple platforms `URLSession.configuration` is @NSCopying, but
        // swift-corelibs-foundation returns the stored instance — so without an
        // explicit copy this would unhook the URLCache from the primary session
        // too, on Linux only, where no test would notice.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        // `URLCache.shared` rather than a constructed one: the two-argument
        // initialiser does not exist on swift-corelibs-foundation (it requires
        // `diskPath:`), and the three-argument form is deprecated on Apple —
        // which `--Werror` would reject. The shared instance exists on both.
        configuration.urlCache = .shared
        let session = URLSession(configuration: configuration)

        let adapter = URLSessionHTTPClientAdapter(urlSession: session)
        let url = try #require(URL(string: "https://api.themoviedb.org/4/list/1"))
        _ = adapter.session(for: HTTPRequest(url: url, isUserSpecific: true))

        #expect(session.configuration.urlCache != nil)
        #expect(session.configuration.requestCachePolicy == .useProtocolCachePolicy)
    }

    @Test("an ordinary request still goes through the shared, caching session")
    func ordinaryRequestUsesSharedSession() throws {
        let url = try #require(URL(string: "https://api.themoviedb.org/3/movie/550"))
        let request = HTTPRequest(url: url)

        let session = httpClient.session(for: request)

        #expect(session === urlSession)
    }

    @Test("the cache-free session inherits the injected session's protocol classes")
    func cacheFreeSessionInheritsConfiguration() throws {
        // Without this, a test injecting MockURLProtocol would reach the live
        // network for user-specific requests and the bypass would be untestable.
        let url = try #require(URL(string: "https://api.themoviedb.org/4/list/1"))
        let request = HTTPRequest(url: url, isUserSpecific: true)

        let session = httpClient.session(for: request)
        let classes = try #require(session.configuration.protocolClasses)

        #expect(classes.contains { $0 == MockURLProtocol.self })
    }

    @Test("a user-specific request is sent with a cache-ignoring policy")
    func userSpecificRequestIgnoresCache() async throws {
        MockURLProtocol.responseStatusCode = 200
        let url = try #require(URL(string: "https://api.themoviedb.org/4/list/1"))

        _ = try? await httpClient.perform(
            request: HTTPRequest(url: url, isUserSpecific: true)
        )

        let lastURLRequest = try #require(MockURLProtocol.lastRequest)
        #expect(lastURLRequest.cachePolicy == .reloadIgnoringLocalCacheData)
    }

    @Test("an ordinary request keeps the default cache policy")
    func ordinaryRequestKeepsDefaultCachePolicy() async throws {
        MockURLProtocol.responseStatusCode = 200
        let url = try #require(URL(string: "https://api.themoviedb.org/3/movie/550"))

        _ = try? await httpClient.perform(request: HTTPRequest(url: url))

        let lastURLRequest = try #require(MockURLProtocol.lastRequest)
        #expect(lastURLRequest.cachePolicy == .useProtocolCachePolicy)
    }

}
