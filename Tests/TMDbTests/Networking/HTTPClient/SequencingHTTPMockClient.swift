//
//  SequencingHTTPMockClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

final class SequencingHTTPMockClient: HTTPClient, @unchecked Sendable {

    private var results: [Result<HTTPResponse, Error>] = []
    private var index = 0
    private let lock = NSLock()
    private(set) var performCount = 0
    private(set) var allRequests: [HTTPRequest] = []

    func enqueue(_ result: Result<HTTPResponse, Error>) {
        lock.withLock {
            results.append(result)
        }
    }

    func perform(request: HTTPRequest) async throws -> HTTPResponse {
        let result: Result<HTTPResponse, Error> = lock.withLock {
            performCount += 1
            allRequests.append(request)
            guard index < results.count else {
                preconditionFailure("No more results enqueued.")
            }
            let result = results[index]
            index += 1
            return result
        }

        return try result.get()
    }

}
