//
//  MovieSearchService.swift
//  TMDbMovies
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol MovieSearchService {

  func search(query: String, year: Int?, page: Int?) -> AnyPublisher<MoviePageableListResult, Error>

}

extension MovieSearchService {

  public  func search(query: String, year: Int?, page: Int? = nil) -> AnyPublisher<MoviePageableListResult, Error> {
    search(query: query, year: year, page: page)
  }

}
