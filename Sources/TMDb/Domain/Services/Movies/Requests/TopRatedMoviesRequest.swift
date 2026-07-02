//
//  TopRatedMoviesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TopRatedMoviesRequest: DecodableAPIRequest<MoviePageableList> {

    init(page: Int? = nil, country: String? = nil, language: String? = nil) {
        let path = "/movie/top_rated"
        let queryItems = APIRequestQueryItems(page: page, country: country, language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(page: Int?, country: String?, language: String?) {
        self.init()

        self[ifPresent: .page] = page

        self[ifPresent: .region] = country

        self[ifPresent: .language] = language
    }

}
