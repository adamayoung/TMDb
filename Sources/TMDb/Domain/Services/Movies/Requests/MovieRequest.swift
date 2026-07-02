//
//  MovieRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieRequest: DecodableAPIRequest<Movie> {

    init(id: Movie.ID, language: String? = nil) {
        let path = "/movie/\(id)"
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
