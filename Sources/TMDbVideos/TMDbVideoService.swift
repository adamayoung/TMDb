//
//  TMDbVideoService.swift
//  TMDbVideos
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbVideoService {

  private let apiClient: APIClient

  public init(apiClient: APIClient) {
    self.apiClient = apiClient
  }

}

extension TMDbVideoService: VideoService {

  public func fetch(forMovie movieID: Int) -> AnyPublisher<VideoCollection, Error> {
    apiClient.get(endpoint: .movieVideos(movieID: movieID))
  }

  public func fetch(forTVShow tvShowID: Int) -> AnyPublisher<VideoCollection, Error> {
    apiClient.get(endpoint: .tvShowVideos(tvShowID: tvShowID))
  }

  public func fetch(forTVShow tvShowID: Int, seasonNumber: Int) -> AnyPublisher<VideoCollection, Error> {
    apiClient.get(endpoint: .tvShowSeasonVideos(tvShowID: tvShowID, seasonNumber: seasonNumber))
  }

}
