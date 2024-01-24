//
//  HTTPMockClient.swift
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

final class HTTPMockClient: HTTPClient {

    var result: Result<HTTPResponse, Error>?
    private(set) var lastURL: URL?
    private(set) var lastHeaders: [String: String]?
    private(set) var getCount = 0

    func get(url: URL, headers: [String: String]) async throws -> HTTPResponse {
        lastURL = url
        lastHeaders = headers
        getCount += 1

        guard let result else {
            preconditionFailure("Result not set.")
        }

        return try result.get()
    }

}
