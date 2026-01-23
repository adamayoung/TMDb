//
//  FavouriteTVSeriesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class FavouriteTVSeriesRequest: DecodableAPIRequest<TVSeriesPageableList> {

    init(sortedBy: FavouriteSort? = nil, page: Int? = nil, accountID: Int, sessionID: String) {
        let path = "/account/\(accountID)/favorite/tv"
        let queryItems = APIRequestQueryItems(sortedBy: sortedBy, page: page, sessionID: sessionID)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(sortedBy: FavouriteSort?, page: Int?, sessionID: String) {
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
