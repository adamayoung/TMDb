//
//  MovieWatchProvidersRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieWatchProvidersRequest: DecodableAPIRequest<ShowWatchProviderResult> {

    init(id: Movie.ID) {
        let path = "/movie/\(id)/watch/providers"

        super.init(path: path)
    }

}
