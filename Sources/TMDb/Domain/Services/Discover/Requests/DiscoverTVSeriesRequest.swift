//
//  DiscoverTVSeriesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class DiscoverTVSeriesRequest: DecodableAPIRequest<TVSeriesPageableList> {

    init(
        filter: DiscoverTVSeriesFilter? = nil,
        sortedBy: TVSeriesSort? = nil,
        page: Int? = nil,
        language: String? = nil
    ) {
        let path = "/discover/tv"
        let queryItems = APIRequestQueryItems(
            filter: filter,
            sortedBy: sortedBy,
            page: page,
            language: language
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(
        filter: DiscoverTVSeriesFilter?,
        sortedBy: TVSeriesSort?,
        page: Int?,
        language: String?
    ) {
        self.init()

        if let filter {
            if let originalLanguage = filter.originalLanguage {
                self[.withOriginalLanguage] = originalLanguage
            }

            if let genres = filter.genres {
                self[.withGenres] = genres.map(String.init).joined(separator: ",")
            }
        }

        if let sortedBy {
            self[.sortBy] = sortedBy
        }

        if let page {
            self[.page] = page
        }

        if let language {
            self[.language] = language
        }
    }

}
