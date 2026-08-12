//
//  TMDbAPIClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

final class TMDbAPIClient: UnmappedAPIClient {

    private let credential: APICredential
    private let baseURL: URL
    private let serialiser: any Serialiser
    private let httpClient: any HTTPClient

    init(
        credential: APICredential,
        baseURL: URL,
        serialiser: some Serialiser,
        httpClient: some HTTPClient
    ) {
        self.credential = credential
        self.baseURL = baseURL
        self.serialiser = serialiser
        self.httpClient = httpClient
    }

    func perform<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let httpRequest = try await buildHTTPRequest(from: request)

        let httpResponse: HTTPResponse
        do {
            httpResponse = try await httpClient.perform(request: httpRequest)
        } catch let error {
            // Cancellation is not a network failure. Reporting it as one makes a
            // dismissed SwiftUI `.task {}` look like an outage and invites the
            // caller to retry work they deliberately cancelled.
            if error.isTaskCancellation {
                throw TMDbAPIError.cancelled
            }

            throw TMDbAPIError.network(error)
        }

        try await validate(response: httpResponse, with: serialiser, path: request.path)

        guard let data = httpResponse.data else {
            throw TMDbAPIError.unknown
        }

        let response: Request.Response
        do {
            response = try await serialiser.decode(Request.Response.self, from: data)
        } catch let error {
            throw TMDbAPIError.decode(error)
        }

        return response
    }

}

extension TMDbAPIClient {

    private func buildHTTPRequest(from request: some APIRequest) async throws -> HTTPRequest {
        guard let path = URL(string: request.path) else {
            // Redacted for the same reason as `TMDbErrorContext.endpointPath`: this
            // value reaches a public error a caller may log.
            throw TMDbAPIError.invalidURL(EndpointPathRedactor.redact(request.path))
        }

        var queryItems = request.queryItems
        var headers = request.headers

        // Does this request require a *user's* credential, by any of the three
        // mechanisms TMDb offers? Marking it here — the one place that sees the
        // request before the client credential is applied — keeps the rule out
        // of the individual request classes, where a new user-scoped endpoint
        // could forget it and silently have its private response cached.
        //
        // A client-level bearer token is deliberately NOT included: that is the
        // application's API Read Access Token, sent on every request including
        // wholly public ones, so treating it as user-scoped would disable
        // caching for every `TMDbClient(bearerToken:)`.
        let carriesUserToken = headers["Authorization"] != nil
        let carriesSession = queryItems["session_id"] != nil
        let isGuestSession = request.path.contains("guest_session")
        let isUserSpecific = carriesUserToken || carriesSession || isGuestSession

        // A request that brought its own `Authorization` is authenticated as a
        // specific user (the v4 endpoints thread an access token per call), so
        // the client credential is withheld entirely — both the header and the
        // `api_key` query item — because sending two credentials leaves
        // precedence to the server, which this library should not guess at.
        // Without this, `Authorization` was overwritten below and a user-scoped
        // read would return the *application owner's* data.
        if !carriesUserToken {
            switch credential {
            case .apiKey(let apiKey):
                queryItems["api_key"] = apiKey
            case .bearerToken(let token):
                headers["Authorization"] = "Bearer \(token)"
            }
        }

        let url = urlFromPath(path, queryItems: queryItems)

        let method = Self.method(from: request.method)

        headers["Accept"] = serialiser.mimeType

        var data: Data?
        if let body = request.body {
            do {
                data = try await serialiser.encode(body)
                headers["Content-Type"] = serialiser.mimeType
            } catch let error {
                throw TMDbAPIError.encode(error)
            }
        }

        return HTTPRequest(
            url: url,
            method: method,
            headers: headers,
            body: data,
            isUserSpecific: isUserSpecific
        )
    }

    private func urlFromPath(
        _ path: URL,
        queryItems requestQueryItems: [String: String] = [:]
    ) -> URL {
        guard var urlComponents = URLComponents(url: path, resolvingAgainstBaseURL: true) else {
            return path
        }

        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = "\(baseURL.path)\(urlComponents.path)"
        var queryItems = urlComponents.queryItems ?? []
        // Append query items in a deterministic, name-sorted order so the same
        // logical request always serialises to an identical URL. The unordered
        // `[String: String]` dictionary would otherwise iterate in an arbitrary
        // order, producing a non-canonical URL and silent cache misses for
        // identical requests in `CacheHTTPClient`.
        for requestQueryItem in requestQueryItems.sorted(by: { $0.key < $1.key }) {
            queryItems.append(
                URLQueryItem(name: requestQueryItem.key, value: requestQueryItem.value)
            )
        }

        urlComponents.queryItems = queryItems

        return urlComponents.url ?? path
    }

    private static func method(from apiMethod: APIRequestMethod) -> HTTPRequest.Method {
        switch apiMethod {
        case .get:
            .get

        case .post:
            .post

        case .put:
            .put

        case .delete:
            .delete
        }
    }

    private func validate(
        response: HTTPResponse,
        with serialiser: some Serialiser,
        path: String
    ) async throws {
        let statusCode = response.statusCode
        if (200 ... 299).contains(statusCode) {
            return
        }

        let statusResponse: TMDbStatusResponse? = if let data = response.data {
            try? await serialiser.decode(TMDbStatusResponse.self, from: data)
        } else {
            nil
        }

        let context = TMDbErrorContext(
            httpStatusCode: statusCode,
            tmdbStatusCode: statusResponse.flatMap { TMDbStatusCode(rawValue: $0.statusCode) },
            statusMessage: statusResponse?.statusMessage,
            endpointPath: EndpointPathRedactor.redact(path),
            retryAfter: response.retryAfterDuration
        )

        throw TMDbAPIError(context: context)
    }

}
