//
//  TVSeriesDeleteRatingRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesDeleteRatingRequest: DecodableAPIRequest<SuccessResult> {

    init(tvSeriesID: TVSeries.ID, sessionID: String) {
        let path = "/tv/\(tvSeriesID)/rating"
        let queryItems = APIRequestQueryItems(sessionID: sessionID)

        super.init(path: path, queryItems: queryItems, method: .delete)
    }

}

private extension APIRequestQueryItems {

    init(sessionID: String) {
        self.init()
        self[.sessionID] = sessionID
    }

}
