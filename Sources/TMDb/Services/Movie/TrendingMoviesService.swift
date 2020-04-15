//
//  TrendingMoviesService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TrendingMoviesService {

  func fetchTrending(timeWindow: TrendingTimeWindowFilterType,
                     page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError>

}

extension TrendingMoviesService {

  public func fetchTrending(timeWindow: TrendingTimeWindowFilterType = .default, page: Int? = nil) -> AnyPublisher<MoviePageableListResult, TMDbError> {
    fetchTrending(timeWindow: timeWindow, page: page)
  }

}
