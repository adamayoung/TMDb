import Foundation

#if canImport(Combine)
import Combine
#endif

final class TMDbTrendingService: TrendingService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchMovies(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?,
                     completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: TrendingEndpoint.movies(timeWindow: timeWindow, page: page), completion: completion)
    }

    func fetchTVShows(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?,
                      completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page), completion: completion)
    }

    func fetchPeople(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?,
                     completion: @escaping (Result<PersonPageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: TrendingEndpoint.people(timeWindow: timeWindow, page: page), completion: completion)
    }

}

#if canImport(Combine)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension TMDbTrendingService {

    func moviesPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType,
                         page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: TrendingEndpoint.movies(timeWindow: timeWindow, page: page))
    }

    func tvShowsPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType,
                          page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page))
    }

    func peoplePublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType,
                         page: Int?) -> AnyPublisher<PersonPageableList, TMDbError> {
        apiClient.get(endpoint: TrendingEndpoint.people(timeWindow: timeWindow, page: page))
    }

}
#endif

#if swift(>=5.5) && !os(Linux)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension TMDbTrendingService {

    func movies(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: TrendingEndpoint.movies(timeWindow: timeWindow, page: page))
    }

    func tvShows(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?) async throws -> TVShowPageableList {
        try await apiClient.get(endpoint: TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page))
    }

    func people(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?) async throws -> PersonPageableList {
        try await apiClient.get(endpoint: TrendingEndpoint.people(timeWindow: timeWindow, page: page))
    }

}
#endif
