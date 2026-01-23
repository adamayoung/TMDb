//
//  MultiSearchRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MultiSearchRequest: DecodableAPIRequest<MediaPageableList> {

    init(
        query: String,
        includeAdult: Bool? = nil,
        page: Int? = nil,
        language: String? = nil
    ) {
        let path = "/search/multi"
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

        if let includeAdult {
            self[.includeAdult] = includeAdult
        }

        if let page {
            self[.page] = page
        }

        if let language {
            self[.language] = language
        }
    }

}
