//
//  MovieSearchRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieSearchRequest: DecodableAPIRequest<MoviePageableList> {

    init(
        query: String,
        primaryReleaseYear: Int? = nil,
        country: String? = nil,
        includeAdult: Bool? = nil,
        page: Int? = nil,
        language: String? = nil

    ) {
        let path = "/search/movie"
        let queryItems = APIRequestQueryItems(
            query: query,
            primaryReleaseYear: primaryReleaseYear,
            country: country,
            includeAdult: includeAdult,
            page: page,
            language: language
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(
        query: String,
        primaryReleaseYear: Int?,
        country: String?,
        includeAdult: Bool?,
        page: Int?,
        language: String?
    ) {
        self.init()

        self[.query] = query

        if let primaryReleaseYear {
            self[.primaryReleaseYear] = primaryReleaseYear
        }

        if let country {
            self[.region] = country
        }

        if let includeAdult {
            self[.includeAdult] = includeAdult
        }

        if let page {
            self[.page] = page
        }

        if let language {
            self[.language] = language
        }
    }

}
