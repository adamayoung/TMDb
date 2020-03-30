//
//  TMDbMoviesService.swift
//  TMDbMovies
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbMovieService {

  private let apiClient: APIClient

  public init(apiClient: APIClient) {
    self.apiClient = apiClient
  }

}

extension TMDbMovieService: MovieService {

  public func fetchDiscover(page: Int?) -> AnyPublisher<MoviePageableListResult, Error> {
    apiClient.get(endpoint: .discover(page: page))
  }

  public func fetchTrending(timeWindow: TrendingTimeWindowFilterType,
                            page: Int?) -> AnyPublisher<MoviePageableListResult, Error> {
    apiClient.get(endpoint: .trending(timeWindow: timeWindow, page: page))
  }

  public func fetch(id: Int) -> AnyPublisher<Movie, Error> {
    apiClient.get(endpoint: .movie(movieID: id))
  }

  public func fetchRecommendations(forMovie movieID: Int, page: Int?) -> AnyPublisher<MoviePageableListResult, Error> {
    apiClient.get(endpoint: .recommendations(movieID: movieID, page: page))
  }

  public func fetchSimilar(toMovie movieID: Int, page: Int?) -> AnyPublisher<MoviePageableListResult, Error> {
    apiClient.get(endpoint: .similar(movieID: movieID, page: page))
  }

  public func search(query: String, year: Int?, page: Int?) -> AnyPublisher<MoviePageableListResult, Error> {
    apiClient.get(endpoint: .search(query: query, year: year, page: page))
  }

}
