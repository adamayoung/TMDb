//
//  Endpoint.swift
//  TMDbTVShows
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum Endpoint {

  case discover(page: Int?)
  case trending(timeWindow: TrendingTimeWindowFilterType, page: Int?)
  case tvShow(tvShowID: Int)
  case recommendations(tvShowID: Int, page: Int?)
  case similar(tvShowID: Int, page: Int?)
  case search(query: String, firstAirDateYear: Int?, page: Int?)

}

extension Endpoint {

  var url: URL {
    switch self {
    case .discover(let page):
      return URL(string: "/discover/tv")!
        .appendingPageQueryItem(page)

    case .trending(let timeWindow, let page):
      return URL(string: "/trending/tv/\(timeWindow)")!
        .appendingPageQueryItem(page)

    case .tvShow(let tvShowID):
      return URL(string: "/tv/\(tvShowID)")!

    case .recommendations(let tvShowID, let page):
      return URL(string: "/tv/\(tvShowID)/recommendations")!
        .appendingPageQueryItem(page)

    case .similar(let tvShowID, let page):
      return URL(string: "/tv/\(tvShowID)/similar")!
        .appendingPageQueryItem(page)

    case .search(let query, let firstAirDateYear, let page):
      return URL(string: "/search/tv")!
        .appendingQueryItem(name: "query", value: query)
        .appendingFirstAirDateYearQueryItem(firstAirDateYear)
        .appendingPageQueryItem(page)
    }
  }

}
