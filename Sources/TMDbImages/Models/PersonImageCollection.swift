//
//  PersonImageCollection.swift
//  TMDbImages
//
//  Created by Adam Young on 23/01/2020.
//

import Foundation

public struct PersonImageCollection: Decodable {

  public let id: Int
  public let profiles: [ImageMetadata]

}
