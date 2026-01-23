//
//  CodableAPIRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

class CodableAPIRequest<Body: Encodable & Equatable, Response: Decodable>: APIRequest {

    let id: UUID
    let path: String
    let queryItems: [String: String]
    let method: APIRequestMethod
    let headers: [String: String]
    let body: Body?

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
        let queryItems = queryItems.map { (key: APIRequestQueryItem.Name, value: any CustomStringConvertible) in
            (key.description, value.description)
        }
        self.queryItems = Dictionary(uniqueKeysWithValues: queryItems)
        self.method = method
        self.body = body
        self.headers = headers
    }

    static func == (
        lhs: CodableAPIRequest<Body, Response>,
        rhs: CodableAPIRequest<Body, Response>
    ) -> Bool {
        lhs.path == rhs.path
            && lhs.queryItems == rhs.queryItems
            && lhs.method == rhs.method
            && lhs.headers == rhs.headers
            && lhs.body == rhs.body
    }

}
