//
//  TVSeriesOnTheAirRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesOnTheAirRequest: DecodableAPIRequest<TVSeriesPageableList> {

    init(page: Int? = nil, timezone: String? = nil, language: String? = nil) {
        let path = "/tv/on_the_air"
        let queryItems = APIRequestQueryItems(page: page, timezone: timezone, language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(page: Int?, timezone: String?, language: String?) {
        self.init()

        if let page {
            self[.page] = page
        }

        if let timezone {
            self[.timezone] = timezone
        }

        if let language {
            self[.language] = language
        }
    }

}
