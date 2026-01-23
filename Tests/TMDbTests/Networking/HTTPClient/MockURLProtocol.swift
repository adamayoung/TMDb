//
//  MockURLProtocol.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
