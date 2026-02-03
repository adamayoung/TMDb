//
//  TVSeriesAddRatingRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesAddRatingRequest: CodableAPIRequest<RatingBody, SuccessResult> {

    init(rating: Double, tvSeriesID: TVSeries.ID, sessionID: String) {
        let path = "/tv/\(tvSeriesID)/rating"
        let queryItems = APIRequestQueryItems(sessionID: sessionID)
        let body = RatingBody(value: rating)

        super.init(path: path, queryItems: queryItems, method: .post, body: body)
    }

}

private extension APIRequestQueryItems {

    init(sessionID: String) {
        self.init()
        self[.sessionID] = sessionID
    }

}

struct RatingBody: Encodable, Equatable {

    let value: Double

}
