//
//  TVEpisodeDetailsAppendRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVEpisodeDetailsAppendRequest:
DecodableAPIRequest<TVEpisodeDetailsResponse> {

    init(
        tvSeriesID: TVSeries.ID,
        seasonNumber: Int,
        episodeNumber: Int,
        appendToResponse: TVEpisodeAppendOption,
        language: String? = nil
    ) {
        let path =
            "/tv/\(tvSeriesID)/season/\(seasonNumber)"
                + "/episode/\(episodeNumber)"
        let queryItems = APIRequestQueryItems(
            appendToResponse: appendToResponse,
            language: language
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(
        appendToResponse: TVEpisodeAppendOption,
        language: String?
    ) {
        self.init()

        if !appendToResponse.isEmpty {
            self[.appendToResponse] = appendToResponse.queryValue
        }

        if let language {
            self[.language] = language
        }
    }

}
