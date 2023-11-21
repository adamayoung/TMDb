//
//  TVSeasonsEndpoint.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
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
            return Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)

        case let .images(tvSeriesID, seasonNumber, languageCode):
            return Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("images")
                .appendingImageLanguage(languageCode)

        case let .videos(tvSeriesID, seasonNumber, languageCode):
            return Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("videos")
                .appendingVideoLanguage(languageCode)
        }
    }

}
