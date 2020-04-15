//
//  ImagesConfiguration.swift
//  TMDb
//
//  Created by Adam Young on 08/04/2020.
//

import Foundation

public struct ImagesConfiguration: Decodable {

  public let baseUrl: URL
  public let secureBaseUrl: URL
  public let backdropSizes: [String]
  public let logoSizes: [String]
  public let posterSizes: [String]
  public let profileSizes: [String]
  public let stillSizes: [String]

  public init(baseUrl: URL, secureBaseUrl: URL, backdropSizes: [String], logoSizes: [String], posterSizes: [String], profileSizes: [String], stillSizes: [String]) {
    self.baseUrl = baseUrl
    self.secureBaseUrl = secureBaseUrl
    self.backdropSizes = backdropSizes
    self.logoSizes = logoSizes
    self.posterSizes = posterSizes
    self.profileSizes = profileSizes
    self.stillSizes = stillSizes
  }

}
