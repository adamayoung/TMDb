//
//  AccountRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class AccountRequest: DecodableAPIRequest<AccountDetails> {

    init(sessionID: String) {
        let path = "/account"
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
