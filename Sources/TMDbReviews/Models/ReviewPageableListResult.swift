//
//  ReviewPageableListResult.swift
//  TMDbReviews
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

public struct ReviewPageableListResult: Decodable {

  public let page: Int?
  public let results: [Review]
  public let totalResults: Int?
  public let totalPages: Int?

  public init(page: Int? = 1, results: [Review], totalResults: Int? = 0, totalPages: Int? = 0) {
    self.page = page
    self.results = results
    self.totalResults = totalResults
    self.totalPages = totalPages
  }

}
