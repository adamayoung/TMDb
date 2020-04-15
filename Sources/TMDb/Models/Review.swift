//
//  Review.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

public struct Review: Identifiable, Decodable {

  public let id: String
  public let author: String
  public let content: String

  public init(id: String, author: String, content: String) {
    self.id = id
    self.author = author
    self.content = content
  }

}
