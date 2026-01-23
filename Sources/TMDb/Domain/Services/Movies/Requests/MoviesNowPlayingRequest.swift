//
//  MoviesNowPlayingRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MoviesNowPlayingRequest: DecodableAPIRequest<MoviePageableList> {

    init(page: Int? = nil, country: String? = nil, language: String? = nil) {
        let path = "/movie/now_playing"
        let queryItems = APIRequestQueryItems(page: page, country: country, language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(page: Int?, country: String?, language: String?) {
        self.init()

        if let page {
            self[.page] = page
        }

        if let country {
            self[.region] = country
        }

        if let language {
            self[.language] = language
        }
    }

}
