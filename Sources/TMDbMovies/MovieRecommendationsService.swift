//
//  MovieRecommendationsService.swift
//  TMDbMovies
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol MovieRecommendationsService {

  func fetchRecommendations(forMovie movieID: Int, page: Int?) -> AnyPublisher<MoviePageableListResult, Error>

}

extension MovieRecommendationsService {

  public func fetchRecommendations(forMovie movieID: Int,
                                   page: Int? = nil) -> AnyPublisher<MoviePageableListResult, Error> {
    fetchRecommendations(forMovie: movieID, page: page)
  }

}
