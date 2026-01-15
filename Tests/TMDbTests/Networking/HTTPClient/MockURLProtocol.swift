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

    private static let lock = NSLock()
    private nonisolated(unsafe) static var unsafeData: Data?
    private nonisolated(unsafe) static var unsafeFailError: Error?
    private nonisolated(unsafe) static var unsafeResponseStatusCode: Int?
    private nonisolated(unsafe) static var unsafeLastRequest: URLRequest?

    static var data: Data? {
        get { lock.withLock { unsafeData } }
        set { lock.withLock { unsafeData = newValue } }
    }

    static var failError: Error? {
        get { lock.withLock { unsafeFailError } }
        set { lock.withLock { unsafeFailError = newValue } }
    }

    static var responseStatusCode: Int? {
        get { lock.withLock { unsafeResponseStatusCode } }
        set { lock.withLock { unsafeResponseStatusCode = newValue } }
    }

    private(set) static var lastRequest: URLRequest? {
        get { lock.withLock { unsafeLastRequest } }
        set { lock.withLock { unsafeLastRequest = newValue } }
    }

    override static func canInit(with _: URLRequest) -> Bool {
        true
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        lastRequest = request
        return request
    }

    override func startLoading() {
        let failError = Self.failError
        let data = Self.data
        let statusCode = Self.responseStatusCode ?? 200

        if let failError {
            client?.urlProtocol(self, didFailWithError: failError)
            return
        }

        guard let url = request.url else {
            return
        }

        if let data {
            client?.urlProtocol(self, didLoad: data)
        }

        guard
            let response = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
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

    override func stopLoading() {}

    static func reset() {
        lock.withLock {
            unsafeData = nil
            unsafeFailError = nil
            unsafeResponseStatusCode = 200
            unsafeLastRequest = nil
        }
    }

}
