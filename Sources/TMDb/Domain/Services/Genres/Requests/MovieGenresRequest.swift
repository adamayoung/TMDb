//
//  MovieGenresRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieGenresRequest: DecodableAPIRequest<GenreList> {

    init(language: String? = nil) {
        let path = "/genre/movie/list"
        let queryItems = APIRequestQueryItems(language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(language: String?) {
        self.init()

        self[ifPresent: .language] = language
    }

}
