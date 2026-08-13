//
//  TMDbAPIClientPathValidationTests.swift
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
/// Covers the choke point that refuses a request path whose segments could
/// resolve to a different endpoint (issue #421).
///
/// These drive `TMDbAPIClient` with a hand-written path, which is what lets them
/// cover shapes no current request builder can produce — the raw `?` and `#`
/// break-outs an *unencoded* builder would emit. `TMDbAPIClientPathSafetyTests`
/// covers the same guard through the real builders.
///
@Suite(.tags(.networking))
struct TMDbAPIClientPathValidationTests {

    var apiClient: TMDbAPIClient!
    var baseURL: URL!
    var httpClient: HTTPMockClient!

    init() async {
        self.baseURL = URL(string: "https://some.domain.com/path")
        self.httpClient = await HTTPMockClient()
        self.apiClient = TMDbAPIClient(
            credential: .apiKey("abc123"),
            baseURL: baseURL,
            serialiser: TMDbJSONSerialiser(),
            httpClient: httpClient
        )
    }

    /// A caller-supplied identifier that decodes to a traversal must never be
    /// sent. TMDb's edge percent-decodes the path and then resolves `..`, so
    /// before this guard `/credit/x%2F..%2F..%2Fmovie%2F550` was dispatched as
    /// `…/path/credit/x/../../movie/550` and reached the `movie` endpoint with
    /// the caller's `api_key` attached.
    @Test("perform when path decodes to a traversal throws and sends nothing")
    @MainActor
    func performWhenPathDecodesToTraversalThrowsAndSendsNothing() async {
        let path = "/credit/x%2F..%2F..%2Fmovie%2F550"

        let error = await performExpectingThrow(path: path)

        #expect(error == .invalidURL(path))
        #expect(httpClient.performCount == 0)
        // Asserted on the URL itself so a regression names the endpoint it leaked to.
        #expect(httpClient.lastRequest?.url.absoluteString == nil)
    }

    /// `URL(string:)` splits a raw `?` in a caller-supplied segment into the
    /// query component, and the URL builder previously seeded its query items
    /// from there — ahead of `api_key`. So this is a query-injection vector, not
    /// merely a path one.
    @Test("perform when path breaks out into a query throws and sends nothing")
    @MainActor
    func performWhenPathBreaksOutIntoQueryThrowsAndSendsNothing() async {
        let path = "/guest_session/x?foo=1/rated/movies"

        let error = await performExpectingThrow(path: path)

        // Expectation hardcoded rather than computed with `EndpointPathRedactor`,
        // so a regression in the redactor fails here instead of cancelling out.
        #expect(error == .invalidURL("/guest_session/{guest_session_id}/rated/movies"))
        #expect(httpClient.performCount == 0)
        #expect(httpClient.lastRequest?.url.absoluteString == nil)
    }

    @Test("perform when path breaks out into a fragment throws and sends nothing")
    @MainActor
    func performWhenPathBreaksOutIntoFragmentThrowsAndSendsNothing() async {
        let path = "/guest_session/x#frag/rated/movies"

        let error = await performExpectingThrow(path: path)

        #expect(error == .invalidURL("/guest_session/{guest_session_id}/rated/movies"))
        #expect(httpClient.performCount == 0)
    }

    /// A leading `//` makes `URL(string:)` parse an authority, and `URLComponents`
    /// then carries `user`, `password` and `port` as fields of their own — which
    /// overriding `scheme` and `host` alone would not displace. No current builder
    /// can emit such a path, so this guards the shape rather than a live vector.
    @Test(
        "perform when path carries an authority throws and sends nothing",
        arguments: [
            "//u:p@evil.example.com:8443/credit/550",
            "//evil.example.com/credit/550",
            "https://evil.example.com/credit/550"
        ]
    )
    @MainActor
    func performWhenPathCarriesAnAuthorityThrowsAndSendsNothing(path: String) async {
        let error = await performExpectingThrow(path: path)

        guard case .invalidURL = error else {
            Issue.record("Expected invalidURL but got \(String(describing: error))")
            return
        }

        #expect(httpClient.performCount == 0)
        #expect(httpClient.lastRequest?.url.absoluteString == nil)
    }

    /// `URLComponents.percentEncodedPath`'s setter traps on a badly-encoded
    /// string ("Attempting to set percentEncodedPath with invalid characters"),
    /// which in a library means aborting the host app. Rejecting a malformed
    /// escape here is what keeps that setter unreachable — and because a trap
    /// would take the whole suite down, reaching these assertions at all is
    /// itself the detector, on Linux as well as Apple.
    @Test(
        "perform when path contains a malformed escape throws and sends nothing",
        arguments: ["/credit/a%zz", "/credit/a%2", "/credit/100%", "/credit/%"]
    )
    @MainActor
    func performWhenPathContainsMalformedEscapeThrowsAndSendsNothing(path: String) async {
        let error = await performExpectingThrow(path: path)

        #expect(error == .invalidURL(path))
        #expect(httpClient.performCount == 0)
    }

    /// `EndpointPathRedactor` splits on a literal `/`, so the injected `%2F` sits
    /// inside segment 1 and the whole of it is replaced — the trailing `lists`
    /// does not survive as its own segment.
    @Test("perform when a rejected path carries an account id redacts it in the error")
    @MainActor
    func performWhenRejectedPathCarriesAccountIDRedactsItInTheError() async {
        let error = await performExpectingThrow(path: "/account/..%2Flists")

        #expect(error == .invalidURL("/account/{account_id}"))
        #expect(httpClient.performCount == 0)
    }

    /// Regression for the round-trip this fix removes: reading the decoded
    /// `URLComponents.path` and reassigning it turned `%3D` back into a literal
    /// `=`, undoing the request builder's own encoding.
    @Test("perform preserves percent-encoding that is safe to send")
    @MainActor
    func performPreservesPercentEncodingThatIsSafeToSend() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/credit/abc%3Dy")
        httpClient.result = .success(HTTPResponse())

        _ = try? await apiClient.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)

        #expect(request.url.absoluteString.contains("/credit/abc%3Dy"))
        #expect(!request.url.absoluteString.contains("/credit/abc=y"))
    }

    @MainActor
    private func performExpectingThrow(path: String) async -> TMDbAPIError? {
        let stubRequest = APIStubRequest<String, String>(path: path)
        httpClient.result = .success(HTTPResponse())

        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error {
            return error as? TMDbAPIError
        }

        return nil
    }

}
