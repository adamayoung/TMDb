//
//  DecodableAPIRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

class DecodableAPIRequest<Response: Decodable>: CodableAPIRequest<EmptyBody, Response> {

    init(
        id: UUID = UUID(),
        path: String,
        queryItems: APIRequestQueryItems = [:],
        method: APIRequestMethod = .get,
        headers: [String: String] = [:]
    ) {
        super.init(
            id: id,
            path: path,
            queryItems: queryItems,
            method: method,
            body: nil,
            headers: headers
        )
    }

}

struct EmptyBody: Encodable, Equatable {}
