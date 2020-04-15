//
//  DiscoverMoviesService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol DiscoverMoviesService {

  func fetchDiscover(page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError>

}

extension DiscoverMoviesService {

  public func fetchDiscover(page: Int? = nil) -> AnyPublisher<MoviePageableListResult, TMDbError> {
    fetchDiscover(page: page)
  }

}
