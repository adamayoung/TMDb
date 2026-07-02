//
//  TVSeriesWatchlistRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesWatchlistRequest: DecodableAPIRequest<TVSeriesPageableList> {

    init(sortedBy: WatchlistSort? = nil, page: Int? = nil, accountID: Int, sessionID: String) {
        let path = "/account/\(accountID)/watchlist/tv"
        let queryItems = APIRequestQueryItems(sortedBy: sortedBy, page: page, sessionID: sessionID)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(sortedBy: WatchlistSort?, page: Int?, sessionID: String) {
        self.init()

        self[ifPresent: .sortBy] = sortedBy

        self[ifPresent: .page] = page

        self[.sessionID] = sessionID
    }

}
