//
//  RatedTVEpisodesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class RatedTVEpisodesRequest: DecodableAPIRequest<TVEpisodePageableList> {

    init(sortedBy: RatedSort? = nil, page: Int? = nil, accountID: Int, sessionID: String) {
        let path = "/account/\(accountID)/rated/tv/episodes"
        let queryItems = APIRequestQueryItems(sortedBy: sortedBy, page: page, sessionID: sessionID)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(sortedBy: RatedSort?, page: Int?, sessionID: String) {
        self.init()

        if let sortedBy {
            self[.sortBy] = sortedBy
        }

        if let page {
            self[.page] = page
        }

        self[.sessionID] = sessionID
    }

}
