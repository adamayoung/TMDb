//
//  VideoMetadata.swift
//  TheMovieDatabase
//
//  Created by Adam Young on 23/01/2020.
//

import Foundation

public struct VideoMetadata: Identifiable, Decodable {

  public let id: String
  public let name: String
  public let site: String
  public let key: String
  public let type: VideoType
  public let size: VideoSize

  public init(id: String, name: String, site: String, key: String, type: VideoType, size: VideoSize) {
    self.id = id
    self.name = name
    self.site = site
    self.key = key
    self.type = type
    self.size = size
  }

}
