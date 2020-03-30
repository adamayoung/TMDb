//
//  ImageMetadata.swift
//  TMDbImages
//
//  Created by Adam Young on 23/01/2020.
//

import Foundation

public struct ImageMetadata: Identifiable, Decodable {

  public let filePath: URL
  public let width: Int
  public let height: Int

  public var id: URL {
    filePath
  }

  public init(filePath: URL, width: Int, height: Int) {
    self.filePath = filePath
    self.width = width
    self.height = height
  }

}
