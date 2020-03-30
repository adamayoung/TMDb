//
//  Endpoint.swift
//  TMDbMovies
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum Endpoint {

  case discover(page: Int?)
  case trending(timeWindow: TrendingTimeWindowFilterType, page: Int?)
  case movie(movieID: Int)
  case recommendations(movieID: Int, page: Int?)
  case similar(movieID: Int, page: Int?)
  case search(query: String, year: Int?, page: Int?)

}

extension Endpoint {

  var url: URL {
    switch self {
    case .discover(let page):
      return URL(string: "/discover/movie")!
        .appendingPageQueryItem(page)

    case .trending(let timeWindow, let page):
      return URL(string: "/trending/movie/\(timeWindow)")!
        .appendingPageQueryItem(page)

    case .movie(let movieID):
      return URL(string: "/movie/\(movieID)")!

    case .recommendations(let movieID, let page):
      return URL(string: "/movie/\(movieID)/recommendations")!
        .appendingPageQueryItem(page)

    case .similar(let movieID, let page):
      return URL(string: "/movie/\(movieID)/similar")!
        .appendingPageQueryItem(page)

    case .search(let query, let year, let page):
      return URL(string: "/search/movie")!
        .appendingQueryItem(name: "query", value: query)
        .appendingYearQueryItem(year)
        .appendingPageQueryItem(page)
    }
  }

}
