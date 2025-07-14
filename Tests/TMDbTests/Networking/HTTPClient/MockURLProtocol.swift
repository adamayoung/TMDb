//
//  MockURLProtocol.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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

final class MockURLProtocol: URLProtocol, @unchecked Sendable {

    @MainActor static var data: Data?
    @MainActor static var failError: Error?
    @MainActor static var responseStatusCode: Int?
    @MainActor private(set) static var lastRequest: URLRequest?

    override static func canInit(with _: URLRequest) -> Bool {
        true
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        Task {
            await MainActor.run {
                lastRequest = request
            }
        }

        return request
    }

    override func startLoading() {
        Task {
            if let failError = await Self.failError {
                client?.urlProtocol(self, didFailWithError: failError)
                return
            }

            guard let url = request.url else {
                return
            }

            if let data = await Self.data {
                client?.urlProtocol(self, didLoad: data)
            }

            guard
                let response = await HTTPURLResponse(
                    url: url,
                    statusCode: Self.responseStatusCode ?? 200,
                    httpVersion: "2.0",
                    headerFields: nil
                )
            else {
                client?.urlProtocolDidFinishLoading(self)
                return
            }

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}

    @MainActor
    static func reset() {
        data = nil
        failError = nil
        responseStatusCode = 200
        lastRequest = nil
    }

}
