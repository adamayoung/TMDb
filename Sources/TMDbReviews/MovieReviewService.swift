//
//  MovieReviewService.swift
//  TMDbReviews
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol MovieReviewService {

  func fetch(forMovie movieID: Int, page: Int?) -> AnyPublisher<ReviewPageableListResult, Error>

}

extension MovieReviewService {

  public func fetch(forMovie movieID: Int, page: Int? = nil) -> AnyPublisher<ReviewPageableListResult, Error> {
    fetch(forMovie: movieID, page: page)
  }

}
