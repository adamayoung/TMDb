//
//  TVSeasonRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeasonRequest: DecodableAPIRequest<TVSeason> {

    init(seasonNumber: Int, tvSeriesID: TVSeries.ID, language: String? = nil) {
        let path = "/tv/\(tvSeriesID)/season/\(seasonNumber)"
        let queryItems = APIRequestQueryItems(language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(language: String?) {
        self.init()

        if let language {
            self[.language] = language
        }
    }

}
