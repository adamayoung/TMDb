//
//  TVSeasonImagesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeasonImagesRequest: DecodableAPIRequest<TVSeasonImageCollection> {

    init(seasonNumber: Int, tvSeriesID: TVSeries.ID, languages: [String]? = nil) {
        let path = "/tv/\(tvSeriesID)/season/\(seasonNumber)/images"
        let queryItems = APIRequestQueryItems(languages: languages)

        super.init(path: path, queryItems: queryItems)
    }

}

extension APIRequestQueryItems {

    fileprivate init(languages: [String]?) {
        self.init()

        if var languages {
            languages = Self.removeRegion(from: languages)
            languages.append("null")
            self[.includeImageLanguage] = languages.joined(separator: ",")
        }
    }

    private static func removeRegion(from languages: [String]) -> [String] {
        languages.compactMap { language in
            guard let languageCode = language.split(separator: "-").first else {
                return nil
            }

            return String(languageCode)
        }
    }

}
