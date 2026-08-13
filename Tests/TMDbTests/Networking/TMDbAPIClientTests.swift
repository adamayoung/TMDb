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
            credential: .apiKey(apiKey),
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

        #expect(error == .invalidURL(path))
    }

    /// A caller-supplied identifier that decodes to a traversal must never be
    /// sent. TMDb's edge percent-decodes the path and then resolves `..`, so
    /// before this guard `/credit/x%2F..%2F..%2Fmovie%2F550` was dispatched as
    /// `…/path/credit/x/../../movie/550` and reached the `movie` endpoint with
    /// the caller's `api_key` attached.
    @Test("perform when path decodes to a traversal throws and sends nothing")
    @MainActor
    func performWhenPathDecodesToTraversalThrowsAndSendsNothing() async throws {
        let path = "/credit/x%2F..%2F..%2Fmovie%2F550"
        let stubRequest = APIStubRequest<String, String>(path: path)
        httpClient.result = .success(HTTPResponse())

        var error: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let err {
            error = err as? TMDbAPIError
        }

        #expect(error == .invalidURL(path))
        #expect(httpClient.performCount == 0)
        // Asserted on the URL itself so a regression names the endpoint it leaked to.
        #expect(httpClient.lastRequest?.url.absoluteString == nil)
    }

    // `URL(string:)` splits a raw `?` in a caller-supplied segment into the query
    // component, and `urlFromPath` seeds its query items from there — ahead of
    // `api_key`. So this is a query-injection vector, not merely a path one.
    @Test("perform when path breaks out into a query throws and sends nothing")
    @MainActor
    func performWhenPathBreaksOutIntoQueryThrowsAndSendsNothing() async throws {
        let path = "/guest_session/x?foo=1/rated/movies"
        let stubRequest = APIStubRequest<String, String>(path: path)
        httpClient.result = .success(HTTPResponse())

        var error: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let err {
            error = err as? TMDbAPIError
        }

        #expect(error == .invalidURL(EndpointPathRedactor.redact(path)))
        #expect(httpClient.performCount == 0)
        #expect(httpClient.lastRequest?.url.absoluteString == nil)
    }

    @Test("perform when path breaks out into a fragment throws and sends nothing")
    @MainActor
    func performWhenPathBreaksOutIntoFragmentThrowsAndSendsNothing() async throws {
        let path = "/guest_session/x#frag/rated/movies"
        let stubRequest = APIStubRequest<String, String>(path: path)
        httpClient.result = .success(HTTPResponse())

        var error: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let err {
            error = err as? TMDbAPIError
        }

        #expect(error == .invalidURL(EndpointPathRedactor.redact(path)))
        #expect(httpClient.performCount == 0)
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
    func performWhenPathContainsMalformedEscapeThrowsAndSendsNothing(path: String) async throws {
        let stubRequest = APIStubRequest<String, String>(path: path)
        httpClient.result = .success(HTTPResponse())

        var error: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let err {
            error = err as? TMDbAPIError
        }

        #expect(error == .invalidURL(path))
        #expect(httpClient.performCount == 0)
    }

    /// `EndpointPathRedactor` splits on a literal `/`, so the injected `%2F` sits
    /// inside segment 1 and the whole of it is replaced — the trailing `lists`
    /// does not survive as its own segment.
    @Test("perform when a rejected path carries an account id redacts it in the error")
    @MainActor
    func performWhenRejectedPathCarriesAccountIDRedactsItInTheError() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/account/..%2Flists")
        httpClient.result = .success(HTTPResponse())

        var error: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let err {
            error = err as? TMDbAPIError
        }

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

    @Test("perform builds query items sorted by name for a canonical URL")
    @MainActor
    func performBuildsQueryItemsSortedByNameForCanonicalURL() async throws {
        let stubRequest = APIStubRequest<String, String>(
            path: "/endpoint",
            queryItems: ["zebra": "1", "alpha": "2", "mango": "3"]
        )
        httpClient.result = .success(HTTPResponse())

        _ = try? await apiClient.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)
        let components = try #require(
            URLComponents(url: request.url, resolvingAgainstBaseURL: false)
        )
        let names = try #require(components.queryItems).map(\.name)

        #expect(names == names.sorted())
    }

    @Test("perform builds the same URL regardless of query item insertion order")
    @MainActor
    func performBuildsSameURLRegardlessOfQueryItemInsertionOrder() async throws {
        let firstRequest = APIStubRequest<String, String>(
            path: "/endpoint",
            queryItems: ["zebra": "1", "alpha": "2", "mango": "3"]
        )
        let secondRequest = APIStubRequest<String, String>(
            path: "/endpoint",
            queryItems: ["alpha": "2", "mango": "3", "zebra": "1"]
        )
        httpClient.result = .success(HTTPResponse())

        _ = try? await apiClient.perform(firstRequest)
        let firstURL = try #require(httpClient.lastRequest).url

        _ = try? await apiClient.perform(secondRequest)
        let secondURL = try #require(httpClient.lastRequest).url

        #expect(firstURL.absoluteString == secondURL.absoluteString)
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

    @Test("perform when DELETE method")
    @MainActor
    func performWhenDeleteMethod() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint", method: .delete)
        httpClient.result = .success(HTTPResponse())

        _ = try? await apiClient.perform(stubRequest)

        let request = try #require(httpClient.lastRequest)

        #expect(request.method == .delete)
    }

    @Test("perform when successful returns decoded response")
    @MainActor
    func performWhenSuccessfulReturnsDecodedResponse() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        let expectedResponse = "Hello, World!"
        let responseData = try JSONEncoder().encode(expectedResponse)
        httpClient.result = .success(HTTPResponse(statusCode: 200, data: responseData))

        let response = try await apiClient.perform(stubRequest)

        #expect(response == expectedResponse)
    }

    @Test("perform when network error throws network error")
    @MainActor
    func performWhenNetworkErrorThrowsNetworkError() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        let networkError = URLError(.notConnectedToInternet)
        httpClient.result = .failure(networkError)

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        #expect(thrownError == .network(networkError))
    }

    @Test("perform when response has no data throws unknown error")
    @MainActor
    func performWhenResponseHasNoDataThrowsUnknownError() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        httpClient.result = .success(HTTPResponse(statusCode: 200, data: nil))

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        #expect(thrownError == .unknown)
    }

    @Test("perform when decode fails throws decode error")
    @MainActor
    func performWhenDecodeFailsThrowsDecodeError() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        let invalidData = Data("not valid json".utf8)
        httpClient.result = .success(HTTPResponse(statusCode: 200, data: invalidData))

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        guard case .decode = thrownError else {
            Issue.record("Expected decode error but got \(String(describing: thrownError))")
            return
        }
    }

    @Test("perform when body encode fails throws encode error")
    @MainActor
    func performWhenBodyEncodeFailsThrowsEncodeError() async throws {
        let stubRequest = APIStubRequest<UnencodableValue, String>(
            path: "/endpoint",
            method: .post,
            body: UnencodableValue()
        )
        httpClient.result = .success(HTTPResponse(statusCode: 200, data: Data()))

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        guard case .encode = thrownError else {
            Issue.record("Expected encode error but got \(String(describing: thrownError))")
            return
        }
    }

}

private struct UnencodableValue: Encodable, Equatable {

    func encode(to encoder: Encoder) throws {
        throw EncodingError.invalidValue(
            self,
            EncodingError.Context(
                codingPath: [],
                debugDescription: "Cannot encode UnencodableValue"
            )
        )
    }

}
