//
//  DiscoverMoviesService.swift
//  TMDbMovies
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol DiscoverMoviesService {

  func fetchDiscover(page: Int?) -> AnyPublisher<MoviePageableListResult, Error>

}

extension DiscoverMoviesService {

  public func fetchDiscover(page: Int? = nil) -> AnyPublisher<MoviePageableListResult, Error> {
    fetchDiscover(page: page)
  }

}
