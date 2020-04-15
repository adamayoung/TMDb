//
//  TMDbVideoService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbVideoService {

  private let apiClient: APIClient

  public init(apiClient: APIClient = TMDbAPIClient.shared) {
    self.apiClient = apiClient
  }

}

extension TMDbVideoService: VideoService {

  public func fetch(forMovie movieID: Int) -> AnyPublisher<VideoCollection, TMDbError> {
    apiClient.get(endpoint: VideosEndpoint.movieVideos(movieID: movieID))
  }

  public func fetch(forTVShow tvShowID: Int) -> AnyPublisher<VideoCollection, TMDbError> {
    apiClient.get(endpoint: VideosEndpoint.tvShowVideos(tvShowID: tvShowID))
  }

  public func fetch(forTVShow tvShowID: Int, seasonNumber: Int) -> AnyPublisher<VideoCollection, TMDbError> {
    apiClient.get(endpoint: VideosEndpoint.tvShowSeasonVideos(tvShowID: tvShowID, seasonNumber: seasonNumber))
  }

}
