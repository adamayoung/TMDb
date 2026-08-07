//
//  UpdateV4ListItemsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Updates items already in a list — in practice, setting their comments.
///
/// This is the only endpoint that stores a comment. Add-items accepts one and
/// answers success, but discards it.
///
final class UpdateV4ListItemsRequest: CodableAPIRequest<
    UpdateV4ListItemsRequest.Body, V4ListItemsResult
> {

    convenience init(items: [V4ListItemComment], listID: Int, accessToken: String) {
        let body = UpdateV4ListItemsRequest.Body(items: items)

        self.init(listID: listID, body: body, accessToken: accessToken)
    }

    private init(listID: Int, body: UpdateV4ListItemsRequest.Body, accessToken: String) {
        super.init(
            path: "/list/\(listID)/items",
            method: .put,
            body: body,
            headers: .v4Authorization(accessToken)
        )
    }

}

extension UpdateV4ListItemsRequest {

    struct Body: Encodable, Equatable {

        let items: [V4ListItemComment]

    }

}
