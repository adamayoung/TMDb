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

final class MockAPIClient: APIClient {

    var requestTime: UInt64 = 0

    var lastRequestURL: URL? {
        requestURLs.last
    }

    var lastRequestMethod: MockAPIClient.HTTPMethod? {
        requestMethods.last
    }

    var lastRequestBody: (any Encodable)? {
        requestBodies.last ?? nil
    }

    private var responses: [Result<Any, TMDbAPIError>] = []
    private var requestIndex = 0
    private var requestURLs: [URL] = []
    private var requestMethods: [MockAPIClient.HTTPMethod] = []
    private var requestBodies: [(any Encodable)?] = []

    init() {}

    func addResponse(_ result: Result<Any, TMDbAPIError>) {
        responses.append(result)
    }

    func requestURL(atRequestIndex index: Int) -> URL? {
        guard requestURLs.indices.contains(index) else {
            return nil
        }

        return requestURLs[index]
    }

    func requestMethod(atRequestIndex index: Int) -> MockAPIClient.HTTPMethod? {
        guard requestMethods.indices.contains(index) else {
            return nil
        }

        return requestMethods[index]
    }

    func requestBody(atRequestIndex index: Int) -> (any Encodable)? {
        guard requestURLs.indices.contains(index) else {
            return nil
        }

        return requestBodies[index]
    }

}

extension MockAPIClient {

    enum HTTPMethod {
        case get
        case post
        case delete
    }

}

extension MockAPIClient {

    func get<Response: Decodable>(path: URL) async throws -> Response {
        defer {
            requestIndex += 1
        }

        requestURLs.append(path)
        requestMethods.append(.get)
        requestBodies.append(nil)

        if requestTime > 0 {
            try await Task.sleep(nanoseconds: requestTime * 1_000_000_000)
        }

        guard responses.indices.contains(requestIndex) else {
            preconditionFailure("No response set for request index \(requestIndex)")
        }

        let result = responses[requestIndex]

        do {
            guard let value = try result.get() as? Response else {
                preconditionFailure("Can't cast response to type \(String(describing: Response.self))")
            }

            return value
        } catch let error as TMDbAPIError {
            throw error
        } catch {
            throw TMDbAPIError.unknown
        }
    }

    func post<Response: Decodable>(path: URL, body: some Encodable) async throws -> Response {
        defer {
            requestIndex += 1
        }

        requestURLs.append(path)
        requestMethods.append(.post)
        requestBodies.append(body)

        if requestTime > 0 {
            try await Task.sleep(nanoseconds: requestTime * 1_000_000_000)
        }

        guard responses.indices.contains(requestIndex) else {
            preconditionFailure("No response set for request index \(requestIndex)")
        }

        let result = responses[requestIndex]

        do {
            guard let value = try result.get() as? Response else {
                preconditionFailure("Can't cast response to type \(String(describing: Response.self))")
            }

            return value
        } catch let error as TMDbAPIError {
            throw error
        } catch {
            throw TMDbAPIError.unknown
        }
    }

    func delete<Response: Decodable>(path: URL, body: some Encodable) async throws -> Response {
        defer {
            requestIndex += 1
        }

        requestURLs.append(path)
        requestMethods.append(.delete)
        requestBodies.append(body)

        if requestTime > 0 {
            try await Task.sleep(nanoseconds: requestTime * 1_000_000_000)
        }

        guard responses.indices.contains(requestIndex) else {
            preconditionFailure("No response set for request index \(requestIndex)")
        }

        let result = responses[requestIndex]

        do {
            guard let value = try result.get() as? Response else {
                preconditionFailure("Can't cast response to type \(String(describing: Response.self))")
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
        requestIndex = 0
        responses = []
        requestURLs = []
        requestMethods = []
        requestBodies = []
    }

}
