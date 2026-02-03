//
//  DeleteMovieRatingRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class DeleteMovieRatingRequest: DecodableAPIRequest<SuccessResult> {

    init(movieID: Movie.ID, sessionID: String) {
        let path = "/movie/\(movieID)/rating"
        var queryItems = APIRequestQueryItems()
        queryItems[.sessionID] = sessionID

        super.init(path: path, queryItems: queryItems, method: .delete)
    }

}
