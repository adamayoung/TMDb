//
//  TMDbCreditsService.swift
//  TMDbCredits
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbCreditsService {

  private let apiClient: APIClient

  public init(apiClient: APIClient) {
    self.apiClient = apiClient
  }

}

extension TMDbCreditsService: CreditsService {

  public func fetch(forMovie movieID: Int) -> AnyPublisher<Credits, Error> {
    apiClient.get(endpoint: .movieCredits(movieID: movieID))
  }

  public func fetch(forTVShow tvShowID: Int) -> AnyPublisher<Credits, Error> {
    apiClient.get(endpoint: .tvShowCredits(tvShowID: tvShowID))
  }

}
