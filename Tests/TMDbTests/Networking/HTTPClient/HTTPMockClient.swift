//
//  HTTPMockClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

@MainActor
final class HTTPMockClient: HTTPClient {

    var result: Result<HTTPResponse, Error>?
    private(set) var lastRequest: HTTPRequest?
    private(set) var performCount = 0

    init() {}

    func perform(request: HTTPRequest) async throws -> HTTPResponse {
        lastRequest = request
        performCount += 1

        guard let result else {
            preconditionFailure("Result not set.")
        }

        return try result.get()
    }

}
