import Combine
import Foundation

final class TMDbTrendingService: TrendingService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchMovies(timeWindow: TrendingTimeWindowFilterType,
                     page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        apiClient.get(endpoint: TrendingEndpoint.movies(timeWindow: timeWindow, page: page))
    }

    func fetchTVShows(timeWindow: TrendingTimeWindowFilterType,
                      page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        apiClient.get(endpoint: TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page))
    }

    func fetchPeople(timeWindow: TrendingTimeWindowFilterType,
                     page: Int?) -> AnyPublisher<PersonPageableListDTO, TMDbError> {
        apiClient.get(endpoint: TrendingEndpoint.people(timeWindow: timeWindow, page: page))
    }

}
