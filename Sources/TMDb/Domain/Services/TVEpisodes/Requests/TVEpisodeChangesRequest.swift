//
//  TVEpisodeChangesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVEpisodeChangesRequest:
DecodableAPIRequest<ChangeCollection> {

    init(
        episodeID: Int,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) {
        let path = "/tv/episode/\(episodeID)/changes"
        let queryItems = APIRequestQueryItems(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    static let startDate = APIRequestQueryItem.Name("start_date")
    static let endDate = APIRequestQueryItem.Name("end_date")

    init(startDate: Date?, endDate: Date?, page: Int?) {
        self.init()

        if let startDate {
            self[Self.startDate] = DateFormatter
                .theMovieDatabase
                .string(from: startDate)
        }

        if let endDate {
            self[Self.endDate] = DateFormatter
                .theMovieDatabase
                .string(from: endDate)
        }

        if let page {
            self[.page] = page
        }
    }

}
