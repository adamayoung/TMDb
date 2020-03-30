//
//  Endpoint.swift
//  TMDbCredits
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum Endpoint {

  case movieCredits(movieID: Int)
  case tvShowCredits(tvShowID: Int)

}

extension Endpoint {

  var url: URL {
    switch self {
    case .movieCredits(let movieID):
      return URL(string: "/movie/\(movieID)/credits")!

    case .tvShowCredits(let tvShowID):
      return URL(string: "/tv/\(tvShowID)/credits")!
    }
  }

}
