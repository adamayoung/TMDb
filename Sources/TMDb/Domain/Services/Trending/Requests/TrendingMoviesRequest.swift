//
//  TrendingMoviesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TrendingMoviesRequest: DecodableAPIRequest<MoviePageableList> {

    init(timeWindow: TrendingTimeWindowFilterType, page: Int? = nil, language: String? = nil) {
        let path = "/trending/movie/\(timeWindow.rawValue)"
        let queryItems = APIRequestQueryItems(page: page, language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(page: Int?, language: String?) {
        self.init()

        self[ifPresent: .page] = page

        self[ifPresent: .language] = language
    }

}
