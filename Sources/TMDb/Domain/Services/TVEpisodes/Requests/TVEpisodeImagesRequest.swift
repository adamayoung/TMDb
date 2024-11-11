//
//  TVEpisodeImagesRequest.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

final class TVEpisodeImagesRequest: DecodableAPIRequest<TVEpisodeImageCollection> {

    init(
        episodeNumber: Int,
        seasonNumber: Int,
        tvSeriesID: TVSeries.ID,
        languages: [String]? = nil
    ) {
        let path = "/tv/\(tvSeriesID)/season/\(seasonNumber)/episode/\(episodeNumber)/images"
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
