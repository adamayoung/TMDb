//
//  V4ListItemStatusRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Checks whether a movie or TV series is in a list.
///
/// - Note: TMDb answers **404** when the item is not in the list, rather than
///   returning a present/absent flag, so the calling service maps
///   ``TMDbError/notFound(_:)`` to `false`.
///
final class V4ListItemStatusRequest: DecodableAPIRequest<V4ListItemStatusResult> {

    init(listID: Int, mediaID: Int, mediaType: ShowType, accessToken: String? = nil) {
        let path = "/list/\(listID)/item_status"
        let queryItems = APIRequestQueryItems(mediaID: mediaID, mediaType: mediaType)

        super.init(
            path: path,
            queryItems: queryItems,
            headers: .v4Authorization(accessToken)
        )
    }

}

private extension APIRequestQueryItems {

    init(mediaID: Int, mediaType: ShowType) {
        self.init()

        self[.mediaID] = mediaID
        self[.mediaType] = mediaType.rawValue
    }

}
