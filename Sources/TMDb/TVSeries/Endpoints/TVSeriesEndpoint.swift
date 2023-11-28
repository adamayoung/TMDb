//
//  TVSeriesEndpoint.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

enum TVSeriesEndpoint {

    case details(tvSeriesID: TVSeries.ID)
    case credits(tvSeriesID: TVSeries.ID)
    case reviews(tvSeriesID: TVSeries.ID, page: Int? = nil)
    case images(tvSeriesID: TVSeries.ID, languageCode: String?)
    case videos(tvSeriesID: TVSeries.ID, languageCode: String?)
    case recommendations(tvSeriesID: TVSeries.ID, page: Int? = nil)
    case similar(tvSeriesID: TVSeries.ID, page: Int? = nil)
    case popular(page: Int? = nil)
    case watch(tvSeriesID: TVSeries.ID)

}

extension TVSeriesEndpoint: Endpoint {

    private static let basePath = URL(string: "/tv")!

    var path: URL {
        switch self {
        case let .details(tvSeriesID):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)

        case let .credits(tvSeriesID):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)
                .appendingPathComponent("credits")

        case let .reviews(tvSeriesID, page):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)
                .appendingPathComponent("reviews")
                .appendingPage(page)

        case let .images(tvSeriesID, languageCode):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)
                .appendingPathComponent("images")
                .appendingImageLanguage(languageCode)

        case let .videos(tvSeriesID, languageCode):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)
                .appendingPathComponent("videos")
                .appendingVideoLanguage(languageCode)

        case let .recommendations(tvSeriesID, page):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)
                .appendingPathComponent("recommendations")
                .appendingPage(page)

        case let .similar(tvSeriesID, page):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)
                .appendingPathComponent("similar")
                .appendingPage(page)

        case let .popular(page):
            return Self.basePath
                .appendingPathComponent("popular")
                .appendingPage(page)

        case .watch(let tvSeriesID):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)
                .appendingPathComponent("watch/providers")
        }
    }

}
