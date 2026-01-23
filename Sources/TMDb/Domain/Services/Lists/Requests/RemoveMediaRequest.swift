//
//  RemoveMediaRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class RemoveMediaRequest: CodableAPIRequest<RemoveMediaRequest.Body, SuccessResult> {

    convenience init(mediaID: Int, listID: Int, sessionID: String) {
        let body = RemoveMediaRequest.Body(mediaID: mediaID)

        self.init(body: body, listID: listID, sessionID: sessionID)
    }

    private init(body: RemoveMediaRequest.Body, listID: Int, sessionID: String) {
        let path = "/list/\(listID)/remove_item"
        var queryItems = APIRequestQueryItems()
        queryItems[.sessionID] = sessionID

        super.init(path: path, queryItems: queryItems, body: body)
    }

}

extension RemoveMediaRequest {

    struct Body: Encodable, Equatable {

        let mediaID: Int

    }

}

extension RemoveMediaRequest.Body {

    private enum CodingKeys: String, CodingKey {
        case mediaID = "mediaId"
    }

}
