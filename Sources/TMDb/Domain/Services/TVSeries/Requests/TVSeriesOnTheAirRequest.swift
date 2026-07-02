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

        self[ifPresent: .page] = page

        self[ifPresent: .timezone] = timezone

        self[ifPresent: .language] = language
    }

}
