//
//  TrendingMoviesService.swift
//  TMDbMovies
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TrendingMoviesService {

  func fetchTrending(timeWindow: TrendingTimeWindowFilterType,
                     page: Int?) -> AnyPublisher<MoviePageableListResult, Error>

}

extension TrendingMoviesService {

  public func fetchTrending(timeWindow: TrendingTimeWindowFilterType,
                            page: Int? = nil) -> AnyPublisher<MoviePageableListResult, Error> {
    fetchTrending(timeWindow: timeWindow, page: page)
  }

}
