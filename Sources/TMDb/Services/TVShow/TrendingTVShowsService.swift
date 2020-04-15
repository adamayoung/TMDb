//
//  TrendingTVShowsService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TrendingTVShowsService {

  func fetchTrending(timeWindow: TrendingTimeWindowFilterType, page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError>

}

extension TrendingTVShowsService {

  public func fetchTrending(timeWindow: TrendingTimeWindowFilterType = .default, page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
    fetchTrending(timeWindow: timeWindow, page: page)
  }

}
