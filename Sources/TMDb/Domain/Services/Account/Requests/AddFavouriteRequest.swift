//
//  AddFavouriteRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class AddFavouriteRequest: CodableAPIRequest<AddFavouriteRequest.Body, SuccessResult> {

    convenience init(
        showType: ShowType, showID: Show.ID, isFavourite: Bool, accountID: Int, sessionID: String
    ) {
        let body = AddFavouriteRequest.Body(
            showType: showType, showID: showID, isFavourite: isFavourite
        )

        self.init(body: body, accountID: accountID, sessionID: sessionID)
    }

    private init(body: AddFavouriteRequest.Body, accountID: Int, sessionID: String) {
        let path = "/account/\(accountID)/favorite"
        let queryItems = APIRequestQueryItems(sessionID: sessionID)

        super.init(path: path, queryItems: queryItems, body: body)
    }

}

extension AddFavouriteRequest {

    struct Body: Encodable, Equatable {

        let showType: ShowType
        let showID: Show.ID
        let isFavourite: Bool

    }

}

extension AddFavouriteRequest.Body {

    private enum CodingKeys: String, CodingKey {
        case showType = "mediaType"
        case showID = "mediaId"
        case isFavourite = "favorite"
    }

}

private extension APIRequestQueryItems {

    init(sessionID: String) {
        self.init()

        self[.sessionID] = sessionID
    }

}
