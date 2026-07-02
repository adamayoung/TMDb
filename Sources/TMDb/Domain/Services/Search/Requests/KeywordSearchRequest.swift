//
//  KeywordSearchRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class KeywordSearchRequest: DecodableAPIRequest<KeywordPageableList> {

    init(
        query: String,
        page: Int? = nil
    ) {
        let path = "/search/keyword"
        let queryItems = APIRequestQueryItems(
            query: query,
            page: page
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(query: String, page: Int?) {
        self.init()

        self[.query] = query

        self[ifPresent: .page] = page
    }

}
