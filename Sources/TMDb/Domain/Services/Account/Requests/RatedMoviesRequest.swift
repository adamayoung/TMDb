//
//  RatedMoviesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class RatedMoviesRequest: DecodableAPIRequest<MoviePageableList> {

    init(sortedBy: RatedSort? = nil, page: Int? = nil, accountID: Int, sessionID: String) {
        let path = "/account/\(accountID)/rated/movies"
        let queryItems = APIRequestQueryItems(sortedBy: sortedBy, page: page, sessionID: sessionID)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(sortedBy: RatedSort?, page: Int?, sessionID: String) {
        self.init()

        self[ifPresent: .sortBy] = sortedBy

        self[ifPresent: .page] = page

        self[.sessionID] = sessionID
    }

}
