//
//  TVSeasonAggregateCreditsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeasonAggregateCreditsRequest: DecodableAPIRequest<TVSeasonAggregateCredits> {

    init(seasonNumber: Int, tvSeriesID: TVSeries.ID, language: String? = nil) {
        let path = "/tv/\(tvSeriesID)/season/\(seasonNumber)/aggregate_credits"
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
