//
//  PersonSearchRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class PersonSearchRequest: DecodableAPIRequest<PersonPageableList> {

    init(
        query: String,
        includeAdult: Bool? = nil,
        page: Int? = nil,
        language: String? = nil
    ) {
        let path = "/search/person"
        let queryItems = APIRequestQueryItems(
            query: query,
            includeAdult: includeAdult,
            page: page,
            language: language
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(
        query: String,
        includeAdult: Bool?,
        page: Int?,
        language: String?
    ) {
        self.init()

        self[.query] = query

        self[ifPresent: .includeAdult] = includeAdult

        self[ifPresent: .page] = page

        self[ifPresent: .language] = language
    }

}
