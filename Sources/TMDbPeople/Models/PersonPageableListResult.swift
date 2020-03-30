//
//  PersonPageableListResult.swift
//  TMDbPeople
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

public struct PersonPageableListResult: Decodable {

  public let page: Int?
  public let results: [PersonListResultItem]
  public let totalResults: Int?
  public let totalPages: Int?

  public init(page: Int? = 1, results: [PersonListResultItem], totalResults: Int? = 0, totalPages: Int? = 0) {
    self.page = page
    self.results = results
    self.totalResults = totalResults
    self.totalPages = totalPages
  }

}
