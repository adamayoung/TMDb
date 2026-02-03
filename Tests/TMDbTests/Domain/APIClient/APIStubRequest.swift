//
//  APIStubRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

final class APIStubRequest<Body: Encodable & Equatable & Sendable, Response: Decodable>:
APIRequest, Equatable, Sendable {

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
    -> Bool {
        lhs.id == rhs.id
            && lhs.path == rhs.path
            && lhs.queryItems == rhs.queryItems
            && lhs.method == rhs.method
            && lhs.headers == rhs.headers
            && lhs.body == rhs.body
    }

}
