//
//  TVSeriesCreditsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesCreditsRequest: DecodableAPIRequest<ShowCredits> {

    init(id: TVSeries.ID, language: String? = nil) {
        let path = "/tv/\(id)/credits"
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
