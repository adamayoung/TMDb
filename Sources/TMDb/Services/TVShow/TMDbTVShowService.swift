//
//  TMDbTVShowService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbTVShowService {

  private let apiClient: APIClient

  public init(apiClient: APIClient = TMDbAPIClient.shared) {
    self.apiClient = apiClient
  }

}

extension TMDbTVShowService: TVShowService {

  public func fetchDiscover(page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
    apiClient.get(endpoint: TVShowsEndpoint.discover(page: page))
  }

  public func fetchTrending(timeWindow: TrendingTimeWindowFilterType, page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
    apiClient.get(endpoint: TVShowsEndpoint.trending(timeWindow: timeWindow, page: page))
  }

  public func fetch(id: Int) -> AnyPublisher<TVShow, TMDbError> {
    apiClient.get(endpoint: TVShowsEndpoint.tvShow(tvShowID: id))
  }

  public func fetchRecommendations(forTVShow tvShowID: Int, page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
    apiClient.get(endpoint: TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page))
  }

  public func fetchSimilar(toTVShow tvShowID: Int, page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
    apiClient.get(endpoint: TVShowsEndpoint.similar(tvShowID: tvShowID, page: page))
  }

  public func search(query: String, firstAirDateYear: Int?, page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
    apiClient.get(endpoint: TVShowsEndpoint.search(query: query, firstAirDateYear: firstAirDateYear, page: page))
  }

  public func fetchSeason(_ seasonNumber: Int, forTVShow tvShowID: Int) -> AnyPublisher<TVShowSeason, TMDbError> {
    apiClient.get(endpoint: TVShowsEndpoint.season(tvShowID: tvShowID, seasonNumber: seasonNumber))
  }

}
