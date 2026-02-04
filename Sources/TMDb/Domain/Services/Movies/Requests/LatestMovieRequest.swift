//
//  LatestMovieRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class LatestMovieRequest: DecodableAPIRequest<Movie> {

    init() {
        let path = "/movie/latest"

        super.init(path: path)
    }

}
