//
//  URLSessionHTTPClientAdapter.swift
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
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

final class URLSessionHTTPClientAdapter: HTTPClient {

    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func get(url: URL, headers: [String: String]) async throws -> HTTPResponse {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        for header in headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await perform(urlRequest)
        } catch let error {
            throw error
        }

        guard let httpURLResponse = response as? HTTPURLResponse else {
            return HTTPResponse(statusCode: -1, data: nil)
        }

        let statusCode = httpURLResponse.statusCode
        return HTTPResponse(statusCode: statusCode, data: data)
    }

}

extension URLSessionHTTPClientAdapter {

    #if canImport(FoundationNetworking)
        private func perform(_ urlRequest: URLRequest) async throws -> (Data, URLResponse) {
            try await withCheckedThrowingContinuation { continuation in
                urlSession.dataTask(with: urlRequest) { data, response, error in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let data, let response else {
                        continuation.resume(throwing: NSError(domain: "uk.co.adam-young.TMDb", code: -1))
                        return
                    }

                    continuation.resume(returning: (data, response))
                }
                .resume()
            }
        }
    #else
        private func perform(_ urlRequest: URLRequest) async throws -> (Data, URLResponse) {
            try await urlSession.data(for: urlRequest)
        }
    #endif

}
