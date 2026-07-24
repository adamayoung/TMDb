//
//  MockAPIClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package final class MockAPIClient: APIClient, @unchecked Sendable {

    package private(set) var requests: [any APIRequest] = []

    package var lastRequest: (any APIRequest)? {
        requests.last
    }

    private var responses: [Result<Any, TMDbError>] = []
    private var requestIndex = 0

    package init() {}

    package func addResponse(_ result: Result<Any, TMDbError>) {
        responses.append(result)
    }

    package func request(atRequestIndex index: Int) -> (any APIRequest)? {
        guard requests.indices.contains(index) else {
            return nil
        }

        return requests[index]
    }

}

package extension MockAPIClient {

    func perform<Request: APIRequest>(
        _ request: Request
    ) async throws(TMDbError) -> Request.Response {
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
                "Can't cast response to type \(String(describing: Request.Response.self))"
            )
        }

        return value
    }

}

package extension MockAPIClient {

    func reset() {
        requests = []
        requestIndex = 0
        responses = []
    }

}
