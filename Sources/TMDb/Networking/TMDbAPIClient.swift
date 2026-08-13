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
        // Redacted for the same reason as `TMDbErrorContext.endpointPath`: this
        // value reaches a public error a caller may log.
        let redactedPath = EndpointPathRedactor.redact(request.path)
        let pathComponents = try Self.pathComponents(for: request.path, redactedAs: redactedPath)

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

        let url = try url(from: pathComponents, queryItems: queryItems, redactedAs: redactedPath)

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

    ///
    /// Parses a request path and refuses it unless every segment stays inert.
    ///
    /// The path is parsed **once**, here, and the parsed value is what both the
    /// validation and the eventual request are built from. Validating one parse
    /// while sending another is the shape that produced #421 in the first place:
    /// the request builders wrote `%2F` and `urlFromPath` read the decoded
    /// `path` getter, so the two disagreed about the same string.
    ///
    private static func pathComponents(
        for path: String,
        redactedAs redactedPath: String
    ) throws -> URLComponents {
        guard let url = URL(string: path),
              let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            throw TMDbAPIError.invalidURL(redactedPath)
        }

        // A request path is a path and nothing else. Anything else surviving the
        // parse means a caller-supplied segment broke out of itself:
        //
        // - a raw `?`/`#` yields a query or fragment, and those items would
        //   otherwise be merged *ahead* of the credential added below;
        // - a leading `//` yields an authority, and `user`/`password`/`port` are
        //   fields of their own that overriding `scheme` and `host` would not
        //   displace.
        //
        // No current builder can emit any of these, so this guards the shape
        // rather than a live vector — but validating only part of what is parsed
        // is how the two representations drifted apart in the first place.
        guard urlComponents.query == nil, urlComponents.fragment == nil,
              urlComponents.scheme == nil, urlComponents.host == nil,
              urlComponents.user == nil, urlComponents.password == nil,
              urlComponents.port == nil
        else {
            throw TMDbAPIError.invalidURL(redactedPath)
        }

        guard URLPathSegmentValidator.isSafe(path: urlComponents.percentEncodedPath) else {
            throw TMDbAPIError.invalidURL(redactedPath)
        }

        return urlComponents
    }

    private func url(
        from pathComponents: URLComponents,
        queryItems requestQueryItems: [String: String] = [:],
        redactedAs redactedPath: String
    ) throws -> URL {
        var urlComponents = pathComponents
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host

        // Composed through the *percent-encoded* views so the client cannot undo
        // its own encoding. The `path` getter decodes, turning an encoded `%2F`
        // back into a real separator (#421); `baseURL.path` is safe to
        // concatenate unencoded because it is library-owned (`/3` or `/4`) and no
        // public initialiser accepts a base URL. This setter traps on a
        // badly-encoded string, which `pathComponents(for:redactedAs:)` has
        // already ruled out by rejecting malformed escapes.
        urlComponents.percentEncodedPath = "\(baseURL.path)\(urlComponents.percentEncodedPath)"

        // Starts empty rather than from `urlComponents.queryItems`: the path is
        // guaranteed to carry no query of its own, so there is nothing of the
        // caller's to preserve — and nothing that could precede `api_key`.
        var queryItems: [URLQueryItem] = []
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

        // Never fall back to an unvalidated URL: the previous `?? path` returned
        // the caller's own string, which is precisely the value under suspicion.
        guard let url = urlComponents.url else {
            throw TMDbAPIError.invalidURL(redactedPath)
        }

        return url
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
