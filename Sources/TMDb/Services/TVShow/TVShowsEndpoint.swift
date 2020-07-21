//
//  TVShowsEndpoint.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum TVShowsEndpoint {

    case discover(page: Int?)
    case trending(timeWindow: TrendingTimeWindowFilterType, page: Int?)
    case tvShow(tvShowID: Int)
    case recommendations(tvShowID: Int, page: Int?)
    case similar(tvShowID: Int, page: Int?)
    case search(query: String, firstAirDateYear: Int?, page: Int?)
    case season(tvShowID: Int, seasonNumber: Int)

}

extension TVShowsEndpoint: Endpoint {

    var url: URL {
        switch self {
        case .discover(let page):
            return URL(string: "/discover/tv")!
                .appendingPage(page)

        case .trending(let timeWindow, let page):
            return URL(string: "/trending/tv/\(timeWindow)")!
                .appendingPage(page)

        case .tvShow(let tvShowID):
            return URL(string: "/tv/\(tvShowID)")!

        case .recommendations(let tvShowID, let page):
            return URL(string: "/tv/\(tvShowID)/recommendations")!
                .appendingPage(page)

        case .similar(let tvShowID, let page):
            return URL(string: "/tv/\(tvShowID)/similar")!
                .appendingPage(page)

        case .search(let query, let firstAirDateYear, let page):
            return URL(string: "/search/tv")!
                .appendingQueryItem(name: "query", value: query)
                .appendingFirstAirDateYear(firstAirDateYear)
                .appendingPage(page)

        case .season(let tvShowID, let seasonNumber):
            return URL(string: "/tv/\(tvShowID)/season/\(seasonNumber)")!
        }
    }

}
