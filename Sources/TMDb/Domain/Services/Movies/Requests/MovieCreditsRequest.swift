//
//  MovieCreditsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieCreditsRequest: DecodableAPIRequest<ShowCredits> {

    init(id: Movie.ID, language: String? = nil) {
        let path = "/movie/\(id)/credits"
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
