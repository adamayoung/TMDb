//
//  MovieAlternativeTitlesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieAlternativeTitlesRequest: DecodableAPIRequest<AlternativeTitleCollection> {

    init(id: Movie.ID, country: String? = nil, language: String? = nil) {
        let path = "/movie/\(id)/alternative_titles"
        let queryItems = APIRequestQueryItems(country: country, language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(country: String?, language: String?) {
        self.init()

        if let country {
            self[.country] = country
        }

        if let language {
            self[.language] = language
        }
    }

}
