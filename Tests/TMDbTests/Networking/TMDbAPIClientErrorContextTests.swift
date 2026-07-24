//
//  TMDbAPIClientErrorContextTests.swift
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
struct TMDbAPIClientErrorContextTests {

    var apiClient: TMDbAPIClient!
    var baseURL: URL!
    var serialiser: TMDbJSONSerialiser!
    var httpClient: HTTPMockClient!

    init() async {
        self.baseURL = URL(string: "https://some.domain.com/path")
        self.serialiser = TMDbJSONSerialiser()
        self.httpClient = await HTTPMockClient()
        self.apiClient = TMDbAPIClient(
            credential: .apiKey("abc123"),
            baseURL: baseURL,
            serialiser: serialiser,
            httpClient: httpClient
        )
    }

    @Test("perform when error response without data builds context with status and path")
    @MainActor
    func performWhenErrorResponseWithoutDataBuildsContext() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        httpClient.result = .success(HTTPResponse(statusCode: 404, data: nil))

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        let expectedContext = TMDbErrorContext(httpStatusCode: 404, endpointPath: "/endpoint")
        #expect(thrownError == .notFound(expectedContext))
    }

    @Test("perform when error response has a body populates the TMDb status code and message")
    @MainActor
    func performWhenErrorResponseWithBodyPopulatesContext() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        let statusResponseJSON = """
        {
            "success": false,
            "status_code": 34,
            "status_message": "The resource you requested could not be found."
        }
        """
        let responseData = Data(statusResponseJSON.utf8)
        httpClient.result = .success(HTTPResponse(statusCode: 404, data: responseData))

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        let expectedContext = TMDbErrorContext(
            httpStatusCode: 404,
            tmdbStatusCode: .resourceNotFound,
            statusMessage: "The resource you requested could not be found.",
            endpointPath: "/endpoint"
        )
        #expect(thrownError == .notFound(expectedContext))
    }

    @Test("perform when 401 response throws unauthorised error with context")
    @MainActor
    func performWhen401ResponseThrowsUnauthorisedError() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        httpClient.result = .success(HTTPResponse(statusCode: 401, data: nil))

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        let expectedContext = TMDbErrorContext(httpStatusCode: 401, endpointPath: "/endpoint")
        #expect(thrownError == .unauthorised(expectedContext))
    }

    @Test("perform when 500 response throws server error with context")
    @MainActor
    func performWhen500ResponseThrowsServerError() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        httpClient.result = .success(HTTPResponse(statusCode: 500, data: nil))

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        let expectedContext = TMDbErrorContext(httpStatusCode: 500, endpointPath: "/endpoint")
        #expect(thrownError == .internalServerError(expectedContext))
    }

    @Test("perform when 429 response surfaces the Retry-After header")
    @MainActor
    func performWhen429ResponseSurfacesRetryAfter() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        httpClient.result = .success(
            HTTPResponse(statusCode: 429, data: nil, headers: ["Retry-After": "5"])
        )

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        let expectedContext = TMDbErrorContext(
            httpStatusCode: 429,
            endpointPath: "/endpoint",
            retryAfter: .seconds(5)
        )
        #expect(thrownError == .tooManyRequests(expectedContext))
    }

    @Test("perform redacts a token-bearing endpoint path in the error context")
    @MainActor
    func performRedactsTokenBearingEndpointPath() async throws {
        let stubRequest = APIStubRequest<String, String>(
            path: "/guest_session/super-secret-token/rated/movies"
        )
        httpClient.result = .success(HTTPResponse(statusCode: 404, data: nil))

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        guard case .notFound(let context) = thrownError else {
            Issue.record("Expected notFound but got \(String(describing: thrownError))")
            return
        }

        #expect(context.endpointPath == "/guest_session/{guest_session_id}/rated/movies")
        #expect(context.endpointPath?.contains("super-secret-token") == false)
    }

    @Test("perform when the path is invalid throws invalidURL with a redacted path")
    @MainActor
    func performWhenPathInvalidThrowsRedactedInvalidURL() async throws {
        // `URL(string:)` rejects an empty path on every supported platform;
        // swift-corelibs-foundation rejects more, which is why the value thrown
        // here goes through the same redactor as `TMDbErrorContext.endpointPath`.
        let stubRequest = APIStubRequest<String, String>(path: "")
        httpClient.result = .success(HTTPResponse())

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        #expect(thrownError == .invalidURL(""))
    }

    @Test("an invalid token-bearing path is redacted before it reaches the error")
    func invalidTokenBearingPathIsRedacted() {
        let redacted = EndpointPathRedactor.redact("/guest_session/super-secret-token/rated")

        #expect(!redacted.contains("super-secret-token"))
        #expect(redacted == "/guest_session/{guest_session_id}/rated")
    }

    @Test("perform when the error body is not a TMDb status response keeps the HTTP context")
    @MainActor
    func performWhenErrorBodyIsNotDecodableKeepsHTTPContext() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        let htmlBody = Data("<html><body>502 Bad Gateway</body></html>".utf8)
        httpClient.result = .success(HTTPResponse(statusCode: 502, data: htmlBody))

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        let expectedContext = TMDbErrorContext(httpStatusCode: 502, endpointPath: "/endpoint")
        #expect(thrownError == .badGateway(expectedContext))
    }

    @Test(
        "error body populates the TMDb status code and message across the mapping table",
        arguments: [
            (
                "error-status-401",
                401,
                TMDbStatusCode.invalidAPIKey,
                "Invalid API key: You must be granted a valid key."
            ),
            (
                "error-status-400",
                400,
                TMDbStatusCode.invalidPage,
                "Invalid page: Pages start at 1 and max at 500. They are expected to be an integer."
            ),
            (
                "error-status-422",
                422,
                TMDbStatusCode.invalidDateRange,
                "Invalid date range: Should be a range no longer than 14 days."
            ),
            (
                "error-status-response",
                404,
                TMDbStatusCode.resourceNotFound,
                "The resource you requested could not be found."
            )
        ]
    )
    @MainActor
    func errorBodyPopulatesContext(
        fixture: String,
        httpStatus: Int,
        tmdbCode: TMDbStatusCode,
        message: String
    ) async throws {
        let data = try Data(fromResource: fixture, withExtension: "json")
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        httpClient.result = .success(HTTPResponse(statusCode: httpStatus, data: data))

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        let context = try #require(thrownError?.errorContext)
        #expect(context.httpStatusCode == httpStatus)
        #expect(context.tmdbStatusCode == tmdbCode)
        #expect(context.statusMessage == message)
    }

}

private extension TMDbAPIError {

    /// The associated context for an HTTP-family error case, for test assertions.
    var errorContext: TMDbErrorContext? {
        switch self {
        case .badRequest(let context), .unauthorised(let context), .forbidden(let context),
             .notFound(let context), .methodNotAllowed(let context), .notAcceptable(let context),
             .unprocessableContent(let context), .tooManyRequests(let context),
             .internalServerError(let context), .notImplemented(let context),
             .badGateway(let context), .serviceUnavailable(let context),
             .gatewayTimeout(let context):
            context

        default:
            nil
        }
    }

}
