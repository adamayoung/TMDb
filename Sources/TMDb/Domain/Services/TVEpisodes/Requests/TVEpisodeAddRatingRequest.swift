//
//  TVEpisodeAddRatingRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVEpisodeAddRatingRequest:
CodableAPIRequest<RatingBody, SuccessResult> {

    init(
        rating: Double,
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
        let body = RatingBody(value: rating)

        super.init(
            path: path,
            queryItems: queryItems,
            method: .post,
            body: body
        )
    }

}

private extension APIRequestQueryItems {

    init(sessionID: String) {
        self.init()
        self[.sessionID] = sessionID
    }

}
