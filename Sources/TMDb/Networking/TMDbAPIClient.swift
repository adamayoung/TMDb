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
    private let localeProvider: any LocaleProviding

    init(
        apiKey: String,
        baseURL: URL,
        httpClient: some HTTPClient,
        localeProvider: some LocaleProviding
    ) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.localeProvider = localeProvider
    }

    func perform<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        guard let path = URL(string: request.path) else {
            throw TMDbAPIError.invalidURL(request.path)
        }

        var queryItems = request.queryItems

        let url = urlFromPath(path, queryItems: request.queryItems)
        var data: Data?
        do {
            data = try await request.bodyData()
        } catch let error {
            throw TMDbAPIError.encode(error)
        }

        let method = Self.method(from: request.method)

        let httpRequest = HTTPRequest(url: url, method: method, headers: request.headers, body: data)

        let httpResponse: HTTPResponse
        do {
            httpResponse = try await httpClient.perform(request: httpRequest)
        } catch let error {
            throw TMDbAPIError.network(error)
        }

        try await validate(response: httpResponse, with: request.serialiser)

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

    private static func method(from apiMethod: APIRequestMethod) -> HTTPRequest.Method {
        switch apiMethod {
        case .get:
            return .get

        case .post:
            return .post

        case .delete:
            return .delete
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
