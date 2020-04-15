//
//  TMDbMoviesService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbMovieService {

  private let apiClient: APIClient

  public init(apiClient: APIClient = TMDbAPIClient.shared) {
    self.apiClient = apiClient
  }

}

extension TMDbMovieService: MovieService {

  public func fetchDiscover(page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError> {
    apiClient.get(endpoint: MoviesEndpoint.discover(page: page))
  }

  public func fetchTrending(timeWindow: TrendingTimeWindowFilterType, page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError> {
    apiClient.get(endpoint: MoviesEndpoint.trending(timeWindow: timeWindow, page: page))
  }

  public func fetch(id: Int) -> AnyPublisher<Movie, TMDbError> {
    apiClient.get(endpoint: MoviesEndpoint.movie(movieID: id))
  }

  public func fetchRecommendations(forMovie movieID: Int, page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError> {
    apiClient.get(endpoint: MoviesEndpoint.recommendations(movieID: movieID, page: page))
  }

  public func fetchSimilar(toMovie movieID: Int, page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError> {
    apiClient.get(endpoint: MoviesEndpoint.similar(movieID: movieID, page: page))
  }

  public func search(query: String, year: Int?, page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError> {
    apiClient.get(endpoint: MoviesEndpoint.search(query: query, year: year, page: page))
  }

}
