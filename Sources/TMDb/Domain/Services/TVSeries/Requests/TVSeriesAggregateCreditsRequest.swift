//
//  TVSeriesAggregateCreditsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesAggregateCreditsRequest: DecodableAPIRequest<TVSeriesAggregateCredits> {

    init(id: TVSeries.ID, language: String? = nil) {
        let path = "/tv/\(id)/aggregate_credits"
        let queryItems = APIRequestQueryItems(language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(language: String?) {
        self.init()

        self[ifPresent: .language] = language
    }

}
