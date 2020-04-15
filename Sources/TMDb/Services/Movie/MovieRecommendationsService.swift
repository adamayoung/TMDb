//
//  MovieRecommendationsService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol MovieRecommendationsService {

  func fetchRecommendations(forMovie movieID: Int, page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError>

}

extension MovieRecommendationsService {

  public func fetchRecommendations(forMovie movieID: Int,
                                   page: Int? = nil) -> AnyPublisher<MoviePageableListResult, TMDbError> {
    fetchRecommendations(forMovie: movieID, page: page)
  }

}
