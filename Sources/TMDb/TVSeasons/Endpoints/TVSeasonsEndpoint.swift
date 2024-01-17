//
//  TVSeasonsEndpoint.swift
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

enum TVSeasonsEndpoint {

    case details(tvSeriesID: TVSeries.ID, seasonNumber: Int)
    case images(tvSeriesID: TVSeries.ID, seasonNumber: Int, languageCode: String?)
    case videos(tvSeriesID: TVSeries.ID, seasonNumber: Int, languageCode: String?)

}

extension TVSeasonsEndpoint: Endpoint {

    private static func basePath(for tvSeriesID: TVSeries.ID) -> URL {
        TVSeriesEndpoint.details(tvSeriesID: tvSeriesID).path
            .appendingPathComponent("season")
    }

    var path: URL {
        switch self {
        case let .details(tvSeriesID, seasonNumber):
            Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)

        case let .images(tvSeriesID, seasonNumber, languageCode):
            Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("images")
                .appendingImageLanguage(languageCode)

        case let .videos(tvSeriesID, seasonNumber, languageCode):
            Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("videos")
                .appendingVideoLanguage(languageCode)
        }
    }

}
