//
//  MockAPIClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@testable import TMDb

final class MockAPIClient: APIClient, @unchecked Sendable {

    private(set) var requests: [any APIRequest] = []

    var lastRequest: (any APIRequest)? {
        requests.last
    }

    private var responses: [Result<Any, TMDbAPIError>] = []
    private var requestIndex = 0

    init() {}

    func addResponse(_ result: Result<Any, TMDbAPIError>) {
        responses.append(result)
    }

    func request(atRequestIndex index: Int) -> (any APIRequest)? {
        guard requests.indices.contains(index) else {
            return nil
        }

        return requests[index]
    }

}

extension MockAPIClient {

    func perform<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        defer {
            requestIndex += 1
        }

        requests.append(request)

        guard responses.indices.contains(requestIndex) else {
            preconditionFailure("No response set for request index \(requestIndex)")
        }

        let result = responses[requestIndex]

        guard let value = try result.get() as? Request.Response else {
            preconditionFailure(
                "Can't cast response to type \(String(describing: Request.Response.self))")
        }

        return value
    }

}

extension MockAPIClient {

    func reset() {
        requests = []
        requestIndex = 0
        responses = []
    }

}
