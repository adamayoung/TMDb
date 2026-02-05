//
//  CompanySearchRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CompanySearchRequest: DecodableAPIRequest<CompanyPageableList> {

    init(
        query: String,
        page: Int? = nil
    ) {
        let path = "/search/company"
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

        if let page {
            self[.page] = page
        }
    }

}
