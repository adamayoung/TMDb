//
//  MovieDetailsAppendRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieDetailsAppendRequest:
DecodableAPIRequest<MovieDetailsResponse> {

    init(
        id: Movie.ID,
        appendToResponse: MovieAppendOption,
        language: String? = nil
    ) {
        let path = "/movie/\(id)"
        let queryItems = APIRequestQueryItems(
            appendToResponse: appendToResponse,
            language: language
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(
        appendToResponse: MovieAppendOption,
        language: String?
    ) {
        self.init()

        self[.appendToResponse] = appendToResponse.queryValue

        if let language {
            self[.language] = language
        }
    }

}
