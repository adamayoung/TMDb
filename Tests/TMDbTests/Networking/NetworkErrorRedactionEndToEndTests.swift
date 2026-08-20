//
//  NetworkErrorRedactionEndToEndTests.swift
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

///
/// The credential redaction of ``NetworkErrorRedactor`` seen from outside: at
/// the ``TMDbAPIClient`` wrap site, through the whole public stack, and against
/// a `URLSession` failure nobody in this suite constructed.
///
@Suite(.tags(.networking))
struct NetworkErrorRedactionEndToEndTests {

    private static let failingURLStringKey = "NSErrorFailingURLStringKey"

    private static func transportError(url urlString: String) -> NSError {
        guard let url = URL(string: urlString) else {
            preconditionFailure("Test URL is not parseable.")
        }

        return NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorTimedOut,
            userInfo: [
                NSURLErrorFailingURLErrorKey: url,
                failingURLStringKey: url.absoluteString,
                NSLocalizedDescriptionKey: "The request timed out."
            ]
        )
    }

    @Test("a transport failure carrying a credential is wrapped with it redacted")
    @MainActor
    func transportFailureCarryingCredentialIsWrappedRedacted() async throws {
        let httpClient = HTTPMockClient()
        let apiClient = try TMDbAPIClient(
            credential: .apiKey("abc123secret"),
            baseURL: #require(URL(string: "https://some.domain.com/3")),
            serialiser: TMDbJSONSerialiser(),
            httpClient: httpClient
        )
        httpClient.result = .failure(
            Self.transportError(url: "https://some.domain.com/3/movie/550?api_key=abc123secret")
        )

        var thrown: Error?
        do {
            _ = try await apiClient.perform(APIStubRequest<String, String>(path: "/movie/550"))
        } catch let error {
            thrown = error
        }

        let error = try #require(thrown as? TMDbAPIError)
        guard case .network(let underlying) = error else {
            Issue.record("Expected a .network error, got \(error).")
            return
        }

        #expect(!String(describing: (underlying as NSError).userInfo).contains("abc123secret"))
    }

    @Test("a transport failure with nothing to redact keeps its own error type")
    @MainActor
    func transportFailureWithNothingToRedactKeepsItsType() async throws {
        let httpClient = HTTPMockClient()
        let apiClient = try TMDbAPIClient(
            credential: .apiKey("abc123secret"),
            baseURL: #require(URL(string: "https://some.domain.com/3")),
            serialiser: TMDbJSONSerialiser(),
            httpClient: httpClient
        )
        httpClient.result = .failure(StubTransportFailure.offline)

        var thrown: Error?
        do {
            _ = try await apiClient.perform(APIStubRequest<String, String>(path: "/movie/550"))
        } catch let error {
            thrown = error
        }

        let error = try #require(thrown as? TMDbAPIError)
        guard case .network(let underlying) = error else {
            Issue.record("Expected a .network error, got \(error).")
            return
        }

        // A consumer-supplied `HTTPClient` throws its own error type, and
        // `catch TMDbError.network(let error as MyTransportError)` must keep
        // matching after this change.
        #expect(underlying as? StubTransportFailure == .offline)
        #expect(underlying.localizedDescription == "The stub transport is offline.")
    }

    @Test("the public TMDbError.network surfaced by TMDbClient carries no api_key")
    func publicNetworkErrorCarriesNoAPIKey() async throws {
        let apiKey = "public-stack-secret"

        // Not `MockURLProtocol`: its `lastRequest` is process-global and other
        // suites drive it concurrently, so reading it back here passes alone and
        // fails in the parallel run. This protocol keeps no cross-test state —
        // it builds the failure from the request in front of it, the way
        // `URLSession` itself does.
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [EchoingFailureURLProtocol.self]

        let client = TMDbClient(
            apiKey: apiKey,
            httpClient: URLSessionHTTPClientAdapter(urlSession: URLSession(configuration: configuration))
        )

        var thrown: (any Error)?
        do {
            _ = try await client.movies.details(forMovie: 550)
        } catch let error {
            thrown = error
        }

        let error = try #require(thrown as? TMDbError)
        guard case .network(let underlying) = error else {
            Issue.record("Expected a .network error, got \(error).")
            return
        }

        // Closes the loop. The failing URL came from the request the client
        // actually sent, so the credential provably WAS in it — an "absent"
        // assertion over a URL this test invented would prove nothing.
        #expect(EchoingFailureURLProtocol.observedURL(containing: apiKey))

        #expect(!String(describing: (underlying as NSError).userInfo).contains(apiKey))
        #expect(!underlying.localizedDescription.contains(apiKey))
    }

    @Test("URLSession still reports the failing URL under the keys the redactor reads")
    func urlSessionStillReportsFailingURLUnderExpectedKeys() async throws {
        // A characterisation test, not a test of this package: every other test
        // here builds the `userInfo` it then asserts on, so if Foundation ever
        // renamed these keys the redactor would silently stop working while
        // they all stayed green (`knowledge/gotchas.md` — *False green*).
        //
        // Port 1 on loopback refuses immediately: no DNS, no internet, no
        // credential, and no dependence on a live TMDb.
        let url = try #require(URL(string: "http://127.0.0.1:1/probe?api_key=characterisation-secret"))
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: configuration)

        var thrown: Error?
        do {
            _ = try await session.data(from: url)
        } catch let error {
            thrown = error
        }

        // Asserted as PRESENCE, deliberately. An "the credential is absent"
        // assertion here would pass just as happily against a failure carrying
        // no URL at all, proving nothing.
        let error = try #require(thrown as NSError?)
        let userInfo = error.userInfo
        #expect(userInfo[NSURLErrorFailingURLErrorKey] != nil)
        #expect(userInfo[Self.failingURLStringKey] != nil)
        #expect(String(describing: userInfo).contains("characterisation-secret"))

        // And the redactor removes it from exactly that shape.
        let redacted = NetworkErrorRedactor.redact(error)
        #expect(!String(describing: (redacted as NSError).userInfo).contains("characterisation-secret"))
    }

}

///
/// A `URLProtocol` that fails every request with an `NSError` shaped the way
/// `URLSession` shapes one — carrying the **request's own** URL under the
/// failing-URL keys.
///
/// Deriving the failure from the request is what makes the end-to-end assertion
/// meaningful: the credential in the redacted error demonstrably came from the
/// client, not from the test.
///
private final class EchoingFailureURLProtocol: URLProtocol, @unchecked Sendable {

    private static let lock = NSLock()
    private nonisolated(unsafe) static var unsafeObservedURLs: [String] = []

    /// Whether any request seen by this protocol carried `value` in its URL.
    static func observedURL(containing value: String) -> Bool {
        lock.withLock { unsafeObservedURLs.contains { $0.contains(value) } }
    }

    override static func canInit(with _: URLRequest) -> Bool {
        true
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }

        Self.lock.withLock { Self.unsafeObservedURLs.append(url.absoluteString) }

        let error = NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorTimedOut,
            userInfo: [
                NSURLErrorFailingURLErrorKey: url,
                "NSErrorFailingURLStringKey": url.absoluteString,
                NSLocalizedDescriptionKey: "The request timed out."
            ]
        )

        client?.urlProtocol(self, didFailWithError: error)
    }

    override func stopLoading() {}

}

private enum StubTransportFailure: Error, LocalizedError, Equatable {

    case offline

    var errorDescription: String? {
        "The stub transport is offline."
    }

}
