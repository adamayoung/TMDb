//
//  SimilarMoviesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class SimilarMoviesRequest: DecodableAPIRequest<MoviePageableList> {

    init(id: Movie.ID, page: Int? = nil, language: String? = nil) {
        let path = "/movie/\(id)/similar"
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
