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
            throw TMDbAPIError.network(error)
        }

        try await validate(response: httpResponse, with: serialiser)

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
            throw TMDbAPIError.invalidURL(request.path)
        }

        var queryItems = request.queryItems
        var headers = request.headers

        switch credential {
        case .apiKey(let apiKey):
            queryItems["api_key"] = apiKey
        case .bearerToken(let token):
            headers["Authorization"] = "Bearer \(token)"
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

        return HTTPRequest(url: url, method: method, headers: headers, body: data)
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

        case .delete:
            .delete
        }
    }

    private func validate(response: HTTPResponse, with serialiser: some Serialiser) async throws {
        let statusCode = response.statusCode
        if (200 ... 299).contains(statusCode) {
            return
        }

        guard let data = response.data else {
            throw TMDbAPIError(statusCode: statusCode, message: nil)
        }

        let statusResponse = try? await serialiser.decode(TMDbStatusResponse.self, from: data)
        let message = statusResponse?.statusMessage

        throw TMDbAPIError(statusCode: statusCode, message: message)
    }

}
