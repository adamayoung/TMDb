//
//  RemoveV4ListItemsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class RemoveV4ListItemsRequest: CodableAPIRequest<
    RemoveV4ListItemsRequest.Body, V4ListItemsResult
> {

    convenience init(items: [V4ListMediaItem], listID: Int, accessToken: String) {
        let body = RemoveV4ListItemsRequest.Body(items: items)

        self.init(listID: listID, body: body, accessToken: accessToken)
    }

    private init(listID: Int, body: RemoveV4ListItemsRequest.Body, accessToken: String) {
        super.init(
            path: "/list/\(listID)/items",
            method: .delete,
            body: body,
            headers: .v4Authorization(accessToken)
        )
    }

}

extension RemoveV4ListItemsRequest {

    struct Body: Encodable, Equatable {

        let items: [V4ListMediaItem]

    }

}
