//
//  TrendingEndpoint.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

enum TrendingEndpoint {

    case movies(timeWindow: TrendingTimeWindowFilterType = .day, page: Int? = nil)
    case tvSeries(timeWindow: TrendingTimeWindowFilterType = .day, page: Int? = nil)
    case people(timeWindow: TrendingTimeWindowFilterType = .day, page: Int? = nil)

}

extension TrendingEndpoint: Endpoint {

    private static let basePath = URL(string: "/trending")!

    var path: URL {
        switch self {
        case let .movies(timeWindow, page):
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingPathComponent(timeWindow)
                .appendingPage(page)

        case let .tvSeries(timeWindow, page):
            return Self.basePath
                .appendingPathComponent("tv")
                .appendingPathComponent(timeWindow)
                .appendingPage(page)

        case let .people(timeWindow, page):
            return Self.basePath
                .appendingPathComponent("person")
                .appendingPathComponent(timeWindow)
                .appendingPage(page)
        }
    }

}
