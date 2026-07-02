//
//  MovieListsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieListsRequest: DecodableAPIRequest<MediaListSummaryPageableList> {

    init(id: Movie.ID, page: Int? = nil, language: String? = nil) {
        let path = "/movie/\(id)/lists"
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
