//
//  TVSeriesSearchRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesSearchRequest: DecodableAPIRequest<TVSeriesPageableList> {

    init(
        query: String,
        firstAirDateYear: Int? = nil,
        year: Int? = nil,
        includeAdult: Bool? = nil,
        page: Int? = nil,
        language: String? = nil
    ) {
        let path = "/search/tv"
        let queryItems = APIRequestQueryItems(
            query: query,
            firstAirDateYear: firstAirDateYear,
            year: year,
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
        firstAirDateYear: Int?,
        year: Int?,
        includeAdult: Bool?,
        page: Int?,
        language: String?
    ) {
        self.init()

        self[.query] = query

        if let firstAirDateYear {
            self[.firstAirDateYear] = firstAirDateYear
        }

        if let year {
            self[.year] = year
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
