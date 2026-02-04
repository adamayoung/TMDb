//
//  TVSeriesAccountStatesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesAccountStatesRequest: DecodableAPIRequest<AccountStates> {

    init(id: TVSeries.ID, sessionID: String) {
        let path = "/tv/\(id)/account_states"
        let queryItems = APIRequestQueryItems(sessionID: sessionID)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(sessionID: String) {
        self.init()
        self[.sessionID] = sessionID
    }

}
