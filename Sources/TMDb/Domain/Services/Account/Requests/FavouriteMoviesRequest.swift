//
//  FavouriteMoviesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class FavouriteMoviesRequest: DecodableAPIRequest<MoviePageableList> {

    init(sortedBy: FavouriteSort? = nil, page: Int? = nil, accountID: Int, sessionID: String) {
        let path = "/account/\(accountID)/favorite/movies"
        let queryItems = APIRequestQueryItems(sortedBy: sortedBy, page: page, sessionID: sessionID)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(sortedBy: FavouriteSort?, page: Int?, sessionID: String) {
        self.init()

        self[ifPresent: .sortBy] = sortedBy

        self[ifPresent: .page] = page

        self[.sessionID] = sessionID
    }

}
