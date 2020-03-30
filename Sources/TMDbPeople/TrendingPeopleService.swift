//
//  TrendingPeopleService.swift
//  TMDbPeople
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TrendingPeopleService {

  func fetchTrending(timeWindow: TrendingTimeWindowFilterType,
                     page: Int?) -> AnyPublisher<PersonPageableListResult, Error>
}

extension TrendingPeopleService {

  public func fetchTrending(timeWindow: TrendingTimeWindowFilterType = .default,
                            page: Int? = nil) -> AnyPublisher<PersonPageableListResult, Error> {
    fetchTrending(timeWindow: timeWindow, page: page)
  }

}
