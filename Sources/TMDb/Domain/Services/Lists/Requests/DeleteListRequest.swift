//
//  DeleteListRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class DeleteListRequest: DecodableAPIRequest<SuccessResult> {

    init(listID: Int, sessionID: String) {
        let path = "/list/\(listID)"
        var queryItems = APIRequestQueryItems()
        queryItems[.sessionID] = sessionID

        super.init(path: path, queryItems: queryItems, method: .delete)
    }

}
