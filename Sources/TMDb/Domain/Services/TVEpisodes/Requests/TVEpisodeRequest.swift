//
//  TVEpisodeRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVEpisodeRequest: DecodableAPIRequest<TVEpisode> {

    init(
        episodeNumber: Int,
        seasonNumber: Int,
        tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) {
        let path = "/tv/\(tvSeriesID)/season/\(seasonNumber)/episode/\(episodeNumber)"
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
