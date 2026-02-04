//
//  MovieAccountStatesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieAccountStatesRequest: DecodableAPIRequest<AccountStates> {

    init(id: Movie.ID, sessionID: String) {
        let path = "/movie/\(id)/account_states"
        var queryItems = APIRequestQueryItems()
        queryItems[.sessionID] = sessionID

        super.init(path: path, queryItems: queryItems)
    }

}
