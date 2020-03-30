//
//  Endpoint.swift
//  TMDbReviews
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum Endpoint {

  case movieReviews(movieID: Int, page: Int?)
  case tvShowReviews(tvShowID: Int, page: Int?)

}

extension Endpoint {

  var url: URL {
    switch self {
    case .movieReviews(let movieID, let page):
      return URL(string: "/movie/\(movieID)/reviews")!
        .appendingPageQueryItem(page)

    case .tvShowReviews(let tvShowID, let page):
      return URL(string: "/tv/\(tvShowID)/reviews")!
        .appendingPageQueryItem(page)
    }
  }

}
