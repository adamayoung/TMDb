//
//  Endpoint.swift
//  TMDbConfiguration
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum Endpoint {

  case configuration

}

extension Endpoint {

  var url: URL {
    switch self {
    case .configuration:
      return URL(string: "/configuration")!
    }
  }

}
