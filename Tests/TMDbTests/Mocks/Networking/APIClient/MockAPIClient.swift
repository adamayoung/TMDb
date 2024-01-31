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

    static var apiKey: String?

    var requestTime: UInt64 = 0

    var result: Result<Any, TMDbAPIError>?
    private(set) var lastPath: URL?
    private(set) var getCount = 0

    var postResult: Result<Any, TMDbAPIError>?
    private(set) var lastPostPath: URL?
    private(set) var lastPostBody: (any Encodable)?
    private(set) var postCount = 0

    init() {}

    static func setAPIKey(_ apiKey: String) {
        Self.apiKey = apiKey
    }

    func get<Response: Decodable>(path: URL) async throws -> Response {
        lastPath = path
        getCount += 1

        if requestTime > 0 {
            try await Task.sleep(nanoseconds: requestTime * 1_000_000_000)
        }

        guard let result else {
            throw TMDbAPIError.unknown
        }

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

    func post<Response: Decodable>(path: URL, body _: some Encodable) async throws -> Response {
        lastPostPath = path
        postCount += 1

        if requestTime > 0 {
            try await Task.sleep(nanoseconds: requestTime * 1_000_000_000)
        }

        guard let postResult else {
            throw TMDbAPIError.unknown
        }

        do {
            guard let value = try postResult.get() as? Response else {
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
        result = nil
        lastPath = nil
        getCount = 0
    }

}
