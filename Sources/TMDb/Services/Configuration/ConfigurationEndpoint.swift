//
//  ConfigurationEndpoint.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum ConfigurationEndpoint {

  case configuration

}

extension ConfigurationEndpoint: Endpoint {

  var url: URL {
    switch self {
    case .configuration:
      return URL(string: "/configuration")!
    }
  }

}
