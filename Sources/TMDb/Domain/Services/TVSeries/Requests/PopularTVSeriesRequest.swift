//
//  PopularTVSeriesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class PopularTVSeriesRequest: DecodableAPIRequest<TVSeriesPageableList> {

    init(page: Int? = nil, language: String? = nil) {
        let path = "/tv/popular"
        let queryItems = APIRequestQueryItems(page: page, language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(page: Int?, language: String? = nil) {
        self.init()

        self[ifPresent: .page] = page

        self[ifPresent: .language] = language
    }

}
