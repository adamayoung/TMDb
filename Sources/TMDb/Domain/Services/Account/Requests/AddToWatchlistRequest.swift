//
//  AddToWatchlistRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class AddToWatchlistRequest: CodableAPIRequest<AddToWatchlistRequest.Body, SuccessResult> {

    convenience init(
        showType: ShowType, showID: Show.ID, isInWatchlist: Bool, accountID: Int, sessionID: String
    ) {
        let body = AddToWatchlistRequest.Body(
            showType: showType, showID: showID, isInWatchlist: isInWatchlist
        )

        self.init(body: body, accountID: accountID, sessionID: sessionID)
    }

    private init(body: AddToWatchlistRequest.Body, accountID: Int, sessionID: String) {
        let path = "/account/\(accountID)/watchlist"
        let queryItems = APIRequestQueryItems(sessionID: sessionID)

        super.init(path: path, queryItems: queryItems, body: body)
    }

}

extension AddToWatchlistRequest {

    struct Body: Encodable, Equatable {

        let showType: ShowType
        let showID: Show.ID
        let isInWatchlist: Bool

    }

}

extension AddToWatchlistRequest.Body {

    private enum CodingKeys: String, CodingKey {
        case showType = "mediaType"
        case showID = "mediaId"
        case isInWatchlist = "watchlist"
    }

}

private extension APIRequestQueryItems {

    init(sessionID: String) {
        self.init()

        self[.sessionID] = sessionID
    }

}
