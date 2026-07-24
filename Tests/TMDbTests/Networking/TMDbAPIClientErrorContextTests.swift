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

}
