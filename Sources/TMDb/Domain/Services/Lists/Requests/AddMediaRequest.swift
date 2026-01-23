//
//  AddMediaRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class AddMediaRequest: CodableAPIRequest<AddMediaRequest.Body, SuccessResult> {

    convenience init(mediaID: Int, listID: Int, sessionID: String) {
        let body = AddMediaRequest.Body(mediaID: mediaID)

        self.init(body: body, listID: listID, sessionID: sessionID)
    }

    private init(body: AddMediaRequest.Body, listID: Int, sessionID: String) {
        let path = "/list/\(listID)/add_item"
        var queryItems = APIRequestQueryItems()
        queryItems[.sessionID] = sessionID

        super.init(path: path, queryItems: queryItems, body: body)
    }

}

extension AddMediaRequest {

    struct Body: Encodable, Equatable {

        let mediaID: Int

    }

}

extension AddMediaRequest.Body {

    private enum CodingKeys: String, CodingKey {
        case mediaID = "mediaId"
    }

}
