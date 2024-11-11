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

class CodableAPIRequest<Body: Encodable & Equatable, Response: Decodable>: APIRequest,
    CustomStringConvertible
{

    let id: UUID
    let path: String
    let queryItems: [String: String]
    let method: APIRequestMethod
    let headers: [String: String]
    let body: Body?

    var description: String {
        var description = """
            APIRequest:
            \tid: \(id.uuidString)
            \tpath: \(path)
            \tqueryItems: \(queryItems.map { "\($0)=\($1)" }.joined(separator: "&"))
            \tmethod: \(method)
            \theaders: \(headers.map { "\($0): \(1)" }.joined(separator: " "))
            """

        if let body {
            description += "\nBody:\n\(body)"
        }

        return description
    }

    init(
        id: UUID = UUID(),
        path: String,
        queryItems: APIRequestQueryItems = [:],
        method: APIRequestMethod = .post,
        body: Body? = nil,
        headers: [String: String] = [:]
    ) {
        self.id = id
        self.path = path
        let queryItems = queryItems.map {
            (key: APIRequestQueryItem.Name, value: any CustomStringConvertible) in
            (key.description, value.description)
        }
        self.queryItems = Dictionary(uniqueKeysWithValues: queryItems)
        self.method = method
        self.body = body
        self.headers = headers
    }

    static func == (lhs: CodableAPIRequest<Body, Response>, rhs: CodableAPIRequest<Body, Response>)
        -> Bool
    {
        lhs.path == rhs.path
            && lhs.queryItems == rhs.queryItems
            && lhs.method == rhs.method
            && lhs.headers == rhs.headers
            && lhs.body == rhs.body
    }

}
