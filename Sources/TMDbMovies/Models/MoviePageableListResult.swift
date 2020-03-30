//
//  MoviePageableListResult.swift
//  TMDbMovies
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

public struct MoviePageableListResult: Decodable {

  public let page: Int?
  public let results: [MovieListResultItem]
  public let totalResults: Int?
  public let totalPages: Int?

  public init(page: Int? = 1, results: [MovieListResultItem], totalResults: Int? = 0, totalPages: Int? = 0) {
    self.page = page
    self.results = results
    self.totalResults = totalResults
    self.totalPages = totalPages
  }

}
