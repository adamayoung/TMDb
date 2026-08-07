//
//  AddV4ListItemsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class AddV4ListItemsRequest: CodableAPIRequest<
    AddV4ListItemsRequest.Body, V4ListItemsResult
> {

    convenience init(items: [V4ListMediaItem], listID: Int, accessToken: String) {
        let body = AddV4ListItemsRequest.Body(items: items)

        self.init(listID: listID, body: body, accessToken: accessToken)
    }

    private init(listID: Int, body: AddV4ListItemsRequest.Body, accessToken: String) {
        super.init(
            path: "/list/\(listID)/items",
            body: body,
            headers: .v4Authorization(accessToken)
        )
    }

}

extension AddV4ListItemsRequest {

    struct Body: Encodable, Equatable {

        let items: [V4ListMediaItem]

    }

}
