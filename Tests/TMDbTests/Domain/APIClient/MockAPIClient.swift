//
//  MockAPIClient.swift
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

@testable import TMDb
import XCTest

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

        do {
            guard let value = try result.get() as? Request.Response else {
                preconditionFailure("Can't cast response to type \(String(describing: Request.Response.self))")
            }

            return value
        } catch let error as TMDbAPIError {
            throw error
        } catch {
            throw TMDbAPIError.unknown
        }
    }

}

extension MockAPIClient {

    func reset() {
        requests = []
        requestIndex = 0
        responses = []
    }

}
