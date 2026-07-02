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
        year: Int? = nil,
        country: String? = nil,
        includeAdult: Bool? = nil,
        page: Int? = nil,
        language: String? = nil

    ) {
        let path = "/search/movie"
        let queryItems = APIRequestQueryItems(
            query: query,
            primaryReleaseYear: primaryReleaseYear,
            year: year,
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
        year: Int?,
        country: String?,
        includeAdult: Bool?,
        page: Int?,
        language: String?
    ) {
        self.init()

        self[.query] = query

        self[ifPresent: .primaryReleaseYear] = primaryReleaseYear

        self[ifPresent: .year] = year

        self[ifPresent: .region] = country

        self[ifPresent: .includeAdult] = includeAdult

        self[ifPresent: .page] = page

        self[ifPresent: .language] = language
    }

}
