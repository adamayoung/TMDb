//
//  SimilarTVShowsService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol SimilarTVShowsService {

  func fetchSimilar(toTVShow tvShowID: Int, page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError>

}

extension SimilarTVShowsService {

  public func fetchSimilar(toTVShow tvShowID: Int,
                           page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
    fetchSimilar(toTVShow: tvShowID, page: page)
  }

}
