//
//  PageableListResult.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

public struct PageableListResult<Result: Decodable & Identifiable>: Decodable {

  public let page: Int?
  public let results: [Result]
  public let totalResults: Int?
  public let totalPages: Int?

  public init(page: Int? = 1, results: [Result], totalResults: Int? = 0, totalPages: Int? = 0) {
    self.page = page
    self.results = results
    self.totalResults = totalResults
    self.totalPages = totalPages
  }

}
