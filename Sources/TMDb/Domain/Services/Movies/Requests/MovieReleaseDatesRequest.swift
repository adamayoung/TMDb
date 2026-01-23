//
//  MovieReleaseDatesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieReleaseDatesRequest: DecodableAPIRequest<MovieReleaseDatesResult> {

    init(id: Movie.ID) {
        let path = "/movie/\(id)/release_dates"

        super.init(path: path)
    }

}
