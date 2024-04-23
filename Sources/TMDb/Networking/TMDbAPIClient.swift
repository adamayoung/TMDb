//
//  TMDbAPIClient.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

final class TMDbAPIClient: APIClient, @unchecked Sendable {

    private let apiKey: String
    private let baseURL: URL
    private let httpClient: any HTTPClient
    private let serialiser: any Serialiser
    private let localeProvider: any LocaleProviding

    init(
        apiKey: String,
        baseURL: URL,
        httpClient: some HTTPClient,
        serialiser: some Serialiser,
        localeProvider: some LocaleProviding
    ) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.serialiser = serialiser
        self.localeProvider = localeProvider
    }

    func get<Response: Decodable>(path: URL) async throws -> Response {
        let url = urlFromPath(path)
        let headers = [
            "Accept": "application/json"
        ]

        let request = HTTPRequest(url: url, headers: headers)
        let responseObject: Response = try await perform(request: request)

        return responseObject
    }

    func post<Response: Decodable>(path: URL, body: some Encodable) async throws -> Response {
        let url = urlFromPath(path)
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let data: Data
        do {
            data = try await serialiser.encode(body)
        } catch let error {
            throw TMDbAPIError.encode(error)
        }

        let request = HTTPRequest(url: url, method: .post, headers: headers, body: data)
        let responseObject: Response = try await perform(request: request)

        return responseObject
    }

    func delete<Response: Decodable>(path: URL, body: some Encodable) async throws -> Response {
        let url = urlFromPath(path)
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let data: Data
        do {
            data = try await serialiser.encode(body)
        } catch let error {
            throw TMDbAPIError.encode(error)
        }

        let request = HTTPRequest(url: url, method: .delete, headers: headers, body: data)
        let responseObject: Response = try await perform(request: request)

        return responseObject
    }

    func perform<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        guard let path = URL(string: request.path) else {
            throw TMDbAPIError.invalidURL(request.path)
        }

        let url = urlFromPath(path, queryItems: request.queryItems)
        var headers = request.headers
        headers["Accept"] = request.serialiser.mimeType

        var data: Data?
        if let body = request.body {
            do {
                data = try await serialiser.encode(body)
                headers["Content-Type"] = request.serialiser.mimeType
            } catch let error {
                throw TMDbAPIError.encode(error)
            }
        }

        let method: HTTPRequest.Method = switch request.method {
        case .get:
            .get
        case .post:
            .post
        case .delete:
            .delete
        }

        let httpRequest = HTTPRequest(url: url, method: method, headers: headers, body: data)
        let httpResponse: HTTPResponse

        do {
            httpResponse = try await httpClient.perform(request: httpRequest)
        } catch let error {
            throw TMDbAPIError.network(error)
        }

        try await validate(response: httpResponse)

        guard let data = httpResponse.data else {
            throw TMDbAPIError.unknown
        }

        let response: Request.Response
        do {
            response = try await request.serialiser.decode(Request.Response.self, from: data)
        } catch let error {
            throw TMDbAPIError.decode(error)
        }

        return response
    }

}

extension TMDbAPIClient {

    private func perform<Response: Decodable>(request: HTTPRequest) async throws -> Response {
        let response: HTTPResponse

        do {
            response = try await httpClient.perform(request: request)
        } catch let error {
            throw TMDbAPIError.network(error)
        }

        let decodedResponse: Response = try await decodeResponse(response: response)

        return decodedResponse
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
        for requestQueryItem in requestQueryItems {
            queryItems.append(URLQueryItem(name: requestQueryItem.key, value: requestQueryItem.value))
        }

        urlComponents.queryItems = queryItems

        return urlComponents.url!
            .appendingAPIKey(apiKey)
            .appendingLanguage(localeProvider.languageCode)
    }

    private func decodeResponse<Response: Decodable>(response: HTTPResponse) async throws -> Response {
        try await validate(response: response)

        guard let data = response.data else {
            throw TMDbAPIError.unknown
        }

        let decodedResponse: Response
        do {
            decodedResponse = try await serialiser.decode(Response.self, from: data)
        } catch let error {
            throw TMDbAPIError.decode(error)
        }

        return decodedResponse
    }

    private func validate(response: HTTPResponse) async throws {
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
