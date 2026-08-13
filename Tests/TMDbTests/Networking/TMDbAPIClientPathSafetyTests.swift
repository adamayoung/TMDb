//
//  TMDbAPIClientPathSafetyTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

///
/// The public contract for issue #421, exercised through the *real* request
/// builders and the real error mapping rather than through a hand-written stub
/// path — so these cover the encoder and the choke point *composing*, which a
/// pre-encoded `APIStubRequest` path cannot.
///
/// The client under test is wired the way `TMDbFactory` wires it
/// (`ErrorMappingAPIClient` over `TMDbAPIClient`), so the error observed here is
/// the public ``TMDbError`` a caller actually receives.
///
@Suite(.tags(.networking))
struct TMDbAPIClientPathSafetyTests {

    var apiClient: ErrorMappingAPIClient!
    var httpClient: HTTPMockClient!
    var baseURL: URL!

    init() async {
        self.baseURL = URL(string: "https://some.domain.com/path")
        self.httpClient = await HTTPMockClient()
        self.apiClient = ErrorMappingAPIClient(
            apiClient: TMDbAPIClient(
                credential: .apiKey("abc123"),
                baseURL: baseURL,
                serialiser: TMDbJSONSerialiser(),
                httpClient: httpClient
            )
        )
    }

    @Test("credit request with a traversal ID throws invalidURL and sends nothing")
    @MainActor
    func creditRequestWithTraversalIDThrowsInvalidURLAndSendsNothing() async throws {
        let request = CreditRequest(id: "x/../../movie/550")
        httpClient.result = .success(HTTPResponse())

        var error: TMDbError?
        do {
            _ = try await apiClient.perform(request)
        } catch let err {
            error = err
        }

        #expect(error == .invalidURL("/credit/x%2F..%2F..%2Fmovie%2F550"))
        #expect(httpClient.performCount == 0)
    }

    /// The guest session id is a bearer-like credential, so a traversal here would
    /// have redirected a *credentialed* request to another endpoint. The thrown
    /// path is redacted, which is why the payload does not appear in the error.
    @Test("guest session request with a traversal ID throws invalidURL and sends nothing")
    @MainActor
    func guestSessionRequestWithTraversalIDThrowsInvalidURLAndSendsNothing() async throws {
        let request = GuestSessionRatedMoviesRequest(guestSessionID: "x/../../movie/550")
        httpClient.result = .success(HTTPResponse())

        var error: TMDbError?
        do {
            _ = try await apiClient.perform(request)
        } catch let err {
            error = err
        }

        #expect(error == .invalidURL("/guest_session/{guest_session_id}/rated/movies"))
        #expect(httpClient.performCount == 0)
    }

    /// Pins the one observable behaviour change: pasting a full IMDb URL into a
    /// search field is a realistic input that previously reached TMDb and came
    /// back as `.notFound`. It is now rejected locally as `.invalidURL`.
    @Test("find request with a pasted URL as the external ID throws invalidURL")
    @MainActor
    func findRequestWithPastedURLAsExternalIDThrowsInvalidURL() async throws {
        let request = FindByIDRequest(
            externalID: "https://www.imdb.com/title/tt0111161/",
            externalSource: .imdbID
        )
        httpClient.result = .success(HTTPResponse())

        var error: TMDbError?
        do {
            _ = try await apiClient.perform(request)
        } catch let err {
            error = err
        }

        guard case .invalidURL = error else {
            Issue.record("Expected invalidURL but got \(String(describing: error))")
            return
        }

        #expect(httpClient.performCount == 0)
    }

    /// A legitimate identifier must be unaffected — the guard rejects only what
    /// could resolve elsewhere, so an ordinary request still reaches the transport.
    @Test("credit request with a real ID still reaches the transport unchanged")
    @MainActor
    func creditRequestWithRealIDStillReachesTheTransport() async throws {
        let request = CreditRequest(id: "52542282760ee313280017f9")
        httpClient.result = .success(HTTPResponse())

        _ = try? await apiClient.perform(request)

        let httpRequest = try #require(httpClient.lastRequest)

        #expect(
            httpRequest.url.absoluteString
                == "https://some.domain.com/path/credit/52542282760ee313280017f9?api_key=abc123"
        )
    }

}
