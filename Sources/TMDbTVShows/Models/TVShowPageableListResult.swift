//
//  TVShowPageableListResult.swift
//  TMDbTVShows
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

public struct TVShowPageableListResult: Decodable {

  public let page: Int?
  public let results: [TVShowListResultItem]
  public let totalResults: Int?
  public let totalPages: Int?

  public init(page: Int? = 1, results: [TVShowListResultItem], totalResults: Int? = 0, totalPages: Int? = 0) {
    self.page = page
    self.results = results
    self.totalResults = totalResults
    self.totalPages = totalPages
  }

}
