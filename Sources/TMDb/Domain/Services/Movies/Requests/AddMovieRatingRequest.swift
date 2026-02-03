//
//  AddMovieRatingRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class AddMovieRatingRequest: CodableAPIRequest<AddMovieRatingRequest.Body, SuccessResult> {

    init(rating: Double, movieID: Movie.ID, sessionID: String) {
        let body = AddMovieRatingRequest.Body(value: rating)
        let path = "/movie/\(movieID)/rating"
        var queryItems = APIRequestQueryItems()
        queryItems[.sessionID] = sessionID

        super.init(path: path, queryItems: queryItems, body: body)
    }

}

extension AddMovieRatingRequest {

    struct Body: Encodable, Equatable {
        let value: Double
    }

}
