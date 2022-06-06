import Foundation

final class TMDbTrendingService: TrendingService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

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
