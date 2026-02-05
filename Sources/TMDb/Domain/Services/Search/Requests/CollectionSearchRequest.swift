//
//  CollectionSearchRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CollectionSearchRequest: DecodableAPIRequest<CollectionPageableList> {

    init(
        query: String,
        page: Int? = nil,
        language: String? = nil
    ) {
        let path = "/search/collection"
        let queryItems = APIRequestQueryItems(
            query: query,
            page: page,
            language: language
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(query: String, page: Int?, language: String?) {
        self.init()

        self[.query] = query

        if let page {
            self[.page] = page
        }

        if let language {
            self[.language] = language
        }
    }

}
