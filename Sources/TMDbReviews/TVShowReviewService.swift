//
//  TVShowReviewService.swift
//  TMDbReviews
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TVShowReviewService {

  func fetch(forTVShow tvShowID: Int, page: Int?) -> AnyPublisher<ReviewPageableListResult, Error>

}

extension TVShowReviewService {

  public func fetch(forTVShow tvShowID: Int, page: Int? = nil) -> AnyPublisher<ReviewPageableListResult, Error> {
    fetch(forTVShow: tvShowID, page: page)
  }

}
