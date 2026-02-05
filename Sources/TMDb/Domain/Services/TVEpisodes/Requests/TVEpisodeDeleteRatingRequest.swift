//
//  TVEpisodeDeleteRatingRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVEpisodeDeleteRatingRequest:
DecodableAPIRequest<SuccessResult> {

    init(
        episodeNumber: Int,
        seasonNumber: Int,
        tvSeriesID: TVSeries.ID,
        sessionID: String
    ) {
        let path = "/tv/\(tvSeriesID)"
            + "/season/\(seasonNumber)"
            + "/episode/\(episodeNumber)/rating"
        let queryItems = APIRequestQueryItems(
            sessionID: sessionID
        )

        super.init(
            path: path,
            queryItems: queryItems,
            method: .delete
        )
    }

}

private extension APIRequestQueryItems {

    init(sessionID: String) {
        self.init()
        self[.sessionID] = sessionID
    }

}
