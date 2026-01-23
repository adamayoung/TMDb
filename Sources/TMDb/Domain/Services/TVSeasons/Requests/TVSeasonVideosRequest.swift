//
//  TVSeasonVideosRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeasonVideosRequest: DecodableAPIRequest<VideoCollection> {

    init(seasonNumber: Int, tvSeriesID: TVSeries.ID, languages: [String]? = nil) {
        let path = "/tv/\(tvSeriesID)/season/\(seasonNumber)/videos"
        let queryItems = APIRequestQueryItems(languages: languages)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(languages: [String]?) {
        self.init()

        if let languages {
            self[.includeVideoLanguage] = languages.joined(separator: ",")
        }
    }

}
