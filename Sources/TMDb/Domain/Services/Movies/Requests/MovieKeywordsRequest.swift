//
//  MovieKeywordsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieKeywordsRequest: DecodableAPIRequest<MovieKeywordsResponse> {

    init(id: Movie.ID) {
        let path = "/movie/\(id)/keywords"

        super.init(path: path)
    }

}
