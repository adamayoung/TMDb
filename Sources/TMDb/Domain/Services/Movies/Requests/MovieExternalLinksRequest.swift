//
//  MovieExternalLinksRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieExternalLinksRequest: DecodableAPIRequest<MovieExternalLinksCollection> {

    init(id: Movie.ID) {
        let path = "/movie/\(id)/external_ids"

        super.init(path: path)
    }

}
