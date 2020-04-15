//
//  ImagesEndpoint.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum ImagesEndpoint {

  case movieImages(movieID: Int)
  case tvShowImages(tvShowID: Int)
  case tvShowSeasonImages(tvShowID: Int, seasonNumber: Int)
  case personImages(personID: Int)

}

extension ImagesEndpoint: Endpoint {

  var url: URL {
    switch self {
    case .movieImages(let movieID):
      return URL(string: "/movie/\(movieID)/images")!

    case .tvShowImages(let tvShowID):
      return URL(string: "/tv/\(tvShowID)/images")!

    case .tvShowSeasonImages(let tvShowID, let seasonNumber):
      return URL(string: "/tv/\(tvShowID)/season/\(seasonNumber)/images")!

    case .personImages(let personID):
      return URL(string: "/person/\(personID)/images")!
    }
  }

}
