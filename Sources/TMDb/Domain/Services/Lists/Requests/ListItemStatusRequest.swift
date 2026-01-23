//
//  ListItemStatusRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class ListItemStatusRequest: DecodableAPIRequest<MediaListItemStatus> {

    init(listID: Int, mediaID: Int) {
        let path = "/list/\(listID)/item_status"
        let queryItems = APIRequestQueryItems(mediaID: mediaID)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(mediaID: Int) {
        self.init()

        self["movie_id"] = mediaID
    }

}
