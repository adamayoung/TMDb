//
//  ClearListRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class ClearListRequest: CodableAPIRequest<ClearListRequest.Body, SuccessResult> {

    convenience init(listID: Int, sessionID: String) {
        let body = ClearListRequest.Body(confirm: true)

        self.init(body: body, listID: listID, sessionID: sessionID)
    }

    private init(body: ClearListRequest.Body, listID: Int, sessionID: String) {
        let path = "/list/\(listID)/clear"
        var queryItems = APIRequestQueryItems()
        queryItems[.sessionID] = sessionID

        super.init(path: path, queryItems: queryItems, body: body)
    }

}

extension ClearListRequest {

    struct Body: Encodable, Equatable {

        let confirm: Bool

    }

}
