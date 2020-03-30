//
//  TMDbReviewService.swift
//  TMDbReviews
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbReviewService {

  private let apiClient: APIClient

  public init(apiClient: APIClient) {
    self.apiClient = apiClient
  }

}

extension TMDbReviewService: ReviewService {

  public func fetch(forMovie movieID: Int, page: Int?) -> AnyPublisher<ReviewPageableListResult, Error> {
    apiClient.get(endpoint: .movieReviews(movieID: movieID, page: page))
  }

  public func fetch(forTVShow tvShowID: Int, page: Int?) -> AnyPublisher<ReviewPageableListResult, Error> {
    apiClient.get(endpoint: .tvShowReviews(tvShowID: tvShowID, page: page))
  }

}
