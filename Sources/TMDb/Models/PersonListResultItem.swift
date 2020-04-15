//
//  PersonListResultItem.swift
//  TMDb
//
//  Created by Adam Young on 21/01/2020.
//

import Foundation

public struct PersonListResultItem: Identifiable, Decodable {

  public let id: Int
  public let name: String?
  public let profilePath: URL?
  public let popularity: Float?
  public let adult: Bool?

  public init(id: Int, name: String? = nil, profilePath: URL? = nil, popularity: Float? = nil, adult: Bool? = nil) {
    self.id = id
    self.name = name
    self.profilePath = profilePath
    self.popularity = popularity
    self.adult = adult
  }

}
