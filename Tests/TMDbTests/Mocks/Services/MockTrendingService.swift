@testable import TMDb
import XCTest

final class MockTrendingService: TrendingService {

    var movies: MoviePageableList?
    private(set) var lastMoviesTimeWindow: TrendingTimeWindowFilterType?
    private(set) var lastMoviesPage: Int?
    var tvShows: TVShowPageableList?
    private(set) var lastTVShowsTimeWindow: TrendingTimeWindowFilterType?
    private(set) var lastTVShowsPage: Int?
    var people: PersonPageableList?
    private(set) var lastPeopleTimeWindow: TrendingTimeWindowFilterType?
    private(set) var lastPeoplePage: Int?

    func movies(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?) async throws -> MoviePageableList {
        lastMoviesTimeWindow = timeWindow
        lastMoviesPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let movies = self.movies else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: movies)
        }
    }

    func tvShows(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?) async throws -> TVShowPageableList {
        lastTVShowsTimeWindow = timeWindow
        lastTVShowsPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let tvShows = self.tvShows else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: tvShows)
        }
    }

    func people(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?) async throws -> PersonPageableList {
        lastPeopleTimeWindow = timeWindow
        lastPeoplePage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let people = self.people else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: people)
        }
    }

}
