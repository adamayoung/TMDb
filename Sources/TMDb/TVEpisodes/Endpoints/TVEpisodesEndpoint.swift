//
//  TVEpisodesEndpoint.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the License );
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

enum TVEpisodesEndpoint {

    case details(tvSeriesID: TVSeries.ID, seasonNumber: Int, episodeNumber: Int)
    case images(tvSeriesID: TVSeries.ID, seasonNumber: Int, episodeNumber: Int, languageCode: String?)
    case videos(tvSeriesID: TVSeries.ID, seasonNumber: Int, episodeNumber: Int, languageCode: String?)

}

extension TVEpisodesEndpoint: Endpoint {

    private static func basePath(for tvSeriesID: TVSeries.ID) -> URL {
        TVSeriesEndpoint.details(tvSeriesID: tvSeriesID).path
            .appendingPathComponent("season")
    }

    var path: URL {
        switch self {
        case let .details(tvSeriesID, seasonNumber, episodeNumber):
            return Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("episode")
                .appendingPathComponent(episodeNumber)

        case let .images(tvSeriesID, seasonNumber, episodeNumber, languageCode):
            return Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("episode")
                .appendingPathComponent(episodeNumber)
                .appendingPathComponent("images")
                .appendingImageLanguage(languageCode)

        case let .videos(tvSeriesID, seasonNumber, episodeNumber, languageCode):
            return Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("episode")
                .appendingPathComponent(episodeNumber)
                .appendingPathComponent("videos")
                .appendingVideoLanguage(languageCode)
        }
    }

}
