//
//  TVSeasonDetailsAppendRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeasonDetailsAppendRequest:
DecodableAPIRequest<TVSeasonDetailsResponse> {

    init(
        tvSeriesID: TVSeries.ID,
        seasonNumber: Int,
        appendToResponse: TVSeasonAppendOption,
        language: String? = nil
    ) {
        let path = "/tv/\(tvSeriesID)/season/\(seasonNumber)"
        let queryItems = APIRequestQueryItems(
            appendToResponse: appendToResponse,
            language: language
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(
        appendToResponse: TVSeasonAppendOption,
        language: String?
    ) {
        self.init()

        if !appendToResponse.isEmpty {
            self[.appendToResponse] = appendToResponse.queryValue
        }

        if let language {
            self[.language] = language
        }
    }

}
