//
//  CodableAPIRequest.swift
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

import Foundation

class CodableAPIRequest<Body: Encodable & Equatable, Response: Decodable>: APIRequest {

    let id = UUID()
    let path: String
    let queryItems: APIRequestQueryItems
    let method: APIRequestMethod
    let headers: [String: String]
    let body: Body?
    let serialiser: any Serialiser

    init(
        path: String,
        queryItems: APIRequestQueryItems = [:],
        method: APIRequestMethod = .post,
        body: Body? = nil,
        headers: [String: String] = [:],
        serialiser: some Serialiser = TMDbJSONSerialiser()
    ) {
        self.path = path
        self.queryItems = queryItems
        self.method = method
        self.body = body
        self.headers = headers
        self.serialiser = serialiser
    }

    static func == (lhs: CodableAPIRequest<Body, Response>, rhs: CodableAPIRequest<Body, Response>) -> Bool {
        lhs.path == rhs.path
            && lhs.queryItems == rhs.queryItems
            && lhs.method == rhs.method
            && lhs.headers == rhs.headers
            && lhs.body == rhs.body
    }

}
