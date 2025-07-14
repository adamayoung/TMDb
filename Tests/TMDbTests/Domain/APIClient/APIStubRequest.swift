//
//  APIStubRequest.swift
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

@testable import TMDb

final class APIStubRequest<Body: Encodable & Equatable & Sendable, Response: Decodable>:
    APIRequest, Equatable, Sendable
{

    let id: UUID
    let path: String
    let queryItems: [String: String]
    let method: APIRequestMethod
    let headers: [String: String]
    let body: Body?

    init(
        id: UUID = UUID(),
        path: String = "",
        queryItems: [String: String] = [:],
        method: APIRequestMethod = .get,
        headers: [String: String] = [:],
        body: Body? = nil
    ) {
        self.id = id
        self.path = path
        self.queryItems = queryItems
        self.method = method
        self.headers = headers
        self.body = body
    }

    static func == (lhs: APIStubRequest<Body, Response>, rhs: APIStubRequest<Body, Response>)
        -> Bool
    {
        lhs.id == rhs.id
            && lhs.path == rhs.path
            && lhs.queryItems == rhs.queryItems
            && lhs.method == rhs.method
            && lhs.headers == rhs.headers
            && lhs.body == rhs.body
    }

}
