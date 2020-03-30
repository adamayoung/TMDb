//
//  ProductionCountry.swift
//  TMDbMovies
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

public struct ProductionCountry: Identifiable, Decodable {

  public let iso31661: String
  public let name: String

  public var id: String {
    iso31661
  }

  public init(iso31661: String, name: String) {
    self.iso31661 = iso31661
    self.name = name
  }

}
