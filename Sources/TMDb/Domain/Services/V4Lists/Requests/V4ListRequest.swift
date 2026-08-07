//
//  V4ListRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class V4ListRequest: DecodableAPIRequest<V4List> {

    init(
        id listID: Int,
        page: Int? = nil,
        sortBy: V4ListSortBy? = nil,
        language: String? = nil,
        accessToken: String? = nil
    ) {
        let path = "/list/\(listID)"
        let queryItems = APIRequestQueryItems(page: page, sortBy: sortBy, language: language)

        super.init(
            path: path,
            queryItems: queryItems,
            headers: .v4Authorization(accessToken)
        )
    }

}

private extension APIRequestQueryItems {

    init(page: Int?, sortBy: V4ListSortBy?, language: String?) {
        self.init()

        self[ifPresent: .page] = page
        self[ifPresent: .sortBy] = sortBy
        self[ifPresent: .language] = language
    }

}
