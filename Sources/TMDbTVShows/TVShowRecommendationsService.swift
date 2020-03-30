//
//  TVShowRecommendationsService.swift
//  TMDbTVShows
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TVShowRecommendationsService {

  func fetchRecommendations(forTVShow tvShowID: Int, page: Int?) -> AnyPublisher<TVShowPageableListResult, Error>

}

extension TVShowRecommendationsService {

  public func fetchRecommendations(forTVShow tvShowID: Int,
                                   page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, Error> {
    fetchRecommendations(forTVShow: tvShowID, page: page)
  }

}
