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
            apiKey: apiKey,
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

        #if canImport(FoundationNetworking)
            #expect(error == .unknown)
        #else
            #expect(error == .invalidURL(path))
        #endif
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

    @Test("perform when error response without data throws error with status code")
    @MainActor
    func performWhenErrorResponseWithoutDataThrowsErrorWithStatusCode() async throws {
        let stubRequest = APIStubRequest<String, String>(path: "/endpoint")
        httpClient.result = .success(HTTPResponse(statusCode: 404, data: nil))

        var thrownError: TMDbAPIError?
        do {
            _ = try await apiClient.perform(stubRequest)
        } catch let error as TMDbAPIError {
            thrownError = error
        }

        #expect(thrownError == .notFound(nil))
    }

    @Test("perform when error response with message throws error with message")
    @MainActor
    func performWhenErrorResponseWithMessageThrowsErrorWithMessage() async throws {
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

        #expect(thrownError == .notFound("The resource you requested could not be found."))
    }

    @Test("perform when 401 response throws unauthorised error")
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

        #expect(thrownError == .unauthorised(nil))
    }

    @Test("perform when 500 response throws server error")
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

        #expect(thrownError == .internalServerError(nil))
    }

}

private struct UnencodableValue: Encodable, Equatable, Sendable {

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
