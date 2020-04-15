//
//  MoviesEndpoint.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum MoviesEndpoint {

  case discover(page: Int?)
  case trending(timeWindow: TrendingTimeWindowFilterType, page: Int?)
  case movie(movieID: Int)
  case recommendations(movieID: Int, page: Int?)
  case similar(movieID: Int, page: Int?)
  case search(query: String, year: Int?, page: Int?)

}

extension MoviesEndpoint: Endpoint {

  var url: URL {
    switch self {
    case .discover(let page):
      return URL(string: "/discover/movie")!
        .appendingPage(page)

    case .trending(let timeWindow, let page):
      return URL(string: "/trending/movie/\(timeWindow)")!
        .appendingPage(page)

    case .movie(let movieID):
      return URL(string: "/movie/\(movieID)")!

    case .recommendations(let movieID, let page):
      return URL(string: "/movie/\(movieID)/recommendations")!
        .appendingPage(page)

    case .similar(let movieID, let page):
      return URL(string: "/movie/\(movieID)/similar")!
        .appendingPage(page)

    case .search(let query, let year, let page):
      return URL(string: "/search/movie")!
        .appendingQueryItem(name: "query", value: query)
        .appendingYear(year)
        .appendingPage(page)
    }
  }

}
