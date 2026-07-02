//
//  WatchProvidersForMoviesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class WatchProvidersForMoviesRequest: DecodableAPIRequest<WatchProviderResult> {

    init(country: String? = nil, language: String? = nil) {
        let path = "/watch/providers/movie"
        let queryItems = APIRequestQueryItems(country: country, language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(country: String?, language: String?) {
        self.init()

        self[ifPresent: .watchRegion] = country

        self[ifPresent: .language] = language
    }

}
