//
//  AccountListsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class AccountListsRequest: DecodableAPIRequest<MediaListPageableList> {

    init(page: Int? = nil, accountID: Int, sessionID: String) {
        let path = "/account/\(accountID)/lists"
        let queryItems = APIRequestQueryItems(page: page, sessionID: sessionID)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(page: Int?, sessionID: String) {
        self.init()

        if let page {
            self[.page] = page
        }

        self[.sessionID] = sessionID
    }

}
