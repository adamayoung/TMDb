//
//  TMDbTVShowService.swift
//  TMDbTVShows
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbTVShowService {

  private let apiClient: APIClient

  public init(apiClient: APIClient) {
    self.apiClient = apiClient
  }

}

extension TMDbTVShowService: TVShowService {

  public func fetchDiscover(page: Int?) -> AnyPublisher<TVShowPageableListResult, Error> {
    apiClient.get(endpoint: .discover(page: page))
  }

  public func fetchTrending(timeWindow: TrendingTimeWindowFilterType,
                            page: Int?) -> AnyPublisher<TVShowPageableListResult, Error> {
    apiClient.get(endpoint: .trending(timeWindow: timeWindow, page: page))
  }

  public func fetch(id: Int) -> AnyPublisher<TVShow, Error> {
    apiClient.get(endpoint: .tvShow(tvShowID: id))
  }

  public func fetchRecommendations(forTVShow tvShowID: Int,
                                   page: Int?) -> AnyPublisher<TVShowPageableListResult, Error> {
    apiClient.get(endpoint: .recommendations(tvShowID: tvShowID, page: page))
  }

  public func fetchSimilar(toTVShow tvShowID: Int, page: Int?) -> AnyPublisher<TVShowPageableListResult, Error> {
    apiClient.get(endpoint: .similar(tvShowID: tvShowID, page: page))
  }

  public func search(query: String, firstAirDateYear: Int?,
                     page: Int?) -> AnyPublisher<TVShowPageableListResult, Error> {
    apiClient.get(endpoint: .search(query: query, firstAirDateYear: firstAirDateYear, page: page))
  }

}
