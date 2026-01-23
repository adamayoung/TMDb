//
//  WatchProviderRegionsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class WatchProviderRegionsRequest: DecodableAPIRequest<WatchProviderRegions> {

    init(language: String? = nil) {
        let path = "/watch/providers/regions"
        let queryItems = APIRequestQueryItems(language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(language: String?) {
        self.init()

        if let language {
            self[.language] = language
        }
    }

}
