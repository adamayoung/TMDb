//
//  CreateListRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CreateListRequest: CodableAPIRequest<CreateListRequest.Body, CreateListResult> {

    convenience init(
        name: String,
        description: String? = nil,
        language: String? = nil,
        isPublic: Bool? = nil,
        sessionID: String
    ) {
        let body = CreateListRequest.Body(
            name: name,
            description: description,
            language: language,
            isPublic: isPublic
        )

        self.init(body: body, sessionID: sessionID)
    }

    private init(body: CreateListRequest.Body, sessionID: String) {
        let path = "/list"
        var queryItems = APIRequestQueryItems()
        queryItems[.sessionID] = sessionID

        super.init(path: path, queryItems: queryItems, body: body)
    }

}

extension CreateListRequest {

    struct Body: Encodable, Equatable {

        let name: String
        let description: String?
        let language: String?
        let isPublic: Bool?

    }

}

extension CreateListRequest.Body {

    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case language = "iso6391"
        case isPublic = "public"
    }

}
