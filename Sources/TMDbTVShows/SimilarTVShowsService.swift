//
//  SimilarTVShowsService.swift
//  TMDbTVShows
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol SimilarTVShowsService {

  func fetchSimilar(toTVShow tvShowID: Int, page: Int?) -> AnyPublisher<TVShowPageableListResult, Error>

}

extension SimilarTVShowsService {

  public func fetchSimilar(toTVShow tvShowID: Int, page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, Error> {
    fetchSimilar(toTVShow: tvShowID, page: page)
  }

}
