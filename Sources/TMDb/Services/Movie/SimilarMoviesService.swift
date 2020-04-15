//
//  SimilarMoviesService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol SimilarMoviesService {

  func fetchSimilar(toMovie movieID: Int, page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError>

}

extension SimilarMoviesService {

  public func fetchSimilar(toMovie movieID: Int, page: Int? = nil) -> AnyPublisher<MoviePageableListResult, TMDbError> {
    fetchSimilar(toMovie: movieID, page: page)
  }

}
