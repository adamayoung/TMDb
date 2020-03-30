//
//  DiscoverTVShowsService.swift
//  TMDbTVShows
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol DiscoverTVShowsService {

  func fetchDiscover(page: Int?) -> AnyPublisher<TVShowPageableListResult, Error>

}

extension DiscoverTVShowsService {

  public func fetchDiscover(page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, Error> {
    fetchDiscover(page: page)
  }

}
