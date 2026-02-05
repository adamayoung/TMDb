//
//  TVEpisodeAccountStatesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVEpisodeAccountStatesRequest:
DecodableAPIRequest<AccountStates> {

    init(
        episodeNumber: Int,
        seasonNumber: Int,
        tvSeriesID: TVSeries.ID,
        sessionID: String
    ) {
        let path = "/tv/\(tvSeriesID)"
            + "/season/\(seasonNumber)"
            + "/episode/\(episodeNumber)/account_states"
        let queryItems = APIRequestQueryItems(
            sessionID: sessionID
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(sessionID: String) {
        self.init()
        self[.sessionID] = sessionID
    }

}
