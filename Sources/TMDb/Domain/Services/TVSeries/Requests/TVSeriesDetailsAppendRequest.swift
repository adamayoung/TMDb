//
//  TVSeriesDetailsAppendRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesDetailsAppendRequest:
DecodableAPIRequest<TVSeriesDetailsResponse> {

    init(
        id: TVSeries.ID,
        appendToResponse: TVSeriesAppendOption,
        language: String? = nil
    ) {
        let path = "/tv/\(id)"
        let queryItems = APIRequestQueryItems(
            appendToResponse: appendToResponse,
            language: language
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(
        appendToResponse: TVSeriesAppendOption,
        language: String?
    ) {
        self.init()

        self[.appendToResponse] = appendToResponse.queryValue

        if let language {
            self[.language] = language
        }
    }

}
