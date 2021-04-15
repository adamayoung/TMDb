import Combine
import Foundation

final class TMDbTrendingService: TrendingService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchMovies(timeWindow: TrendingTimeWindowFilterType,
                     page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: TrendingEndpoint.movies(timeWindow: timeWindow, page: page))
    }

    func fetchTVShows(timeWindow: TrendingTimeWindowFilterType,
                      page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page))
    }

    func fetchPeople(timeWindow: TrendingTimeWindowFilterType,
                     page: Int?) -> AnyPublisher<PersonPageableList, TMDbError> {
        apiClient.get(endpoint: TrendingEndpoint.people(timeWindow: timeWindow, page: page))
    }

}
