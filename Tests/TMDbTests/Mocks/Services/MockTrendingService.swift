@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

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

    func fetchMovies(timeWindow: TrendingTimeWindowFilterType, page: Int?,
                     completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        lastMoviesTimeWindow = timeWindow
        lastMoviesPage = page

        guard let movies = movies else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(movies))
        }
    }

    func fetchTVShows(timeWindow: TrendingTimeWindowFilterType, page: Int?,
                      completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        lastTVShowsTimeWindow = timeWindow
        lastTVShowsPage = page

        guard let tvShows = tvShows else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(tvShows))
        }
    }

    func fetchPeople(timeWindow: TrendingTimeWindowFilterType, page: Int?,
                     completion: @escaping (Result<PersonPageableList, TMDbError>) -> Void) {
        lastPeopleTimeWindow = timeWindow
        lastPeoplePage = page

        guard let people = people else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(people))
        }
    }

}

#if canImport(Combine)
extension MockTrendingService {

    func moviesPublisher(timeWindow: TrendingTimeWindowFilterType,
                         page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        lastMoviesTimeWindow = timeWindow
        lastMoviesPage = page

        guard let movies = movies else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(movies)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func tvShowsPublisher(timeWindow: TrendingTimeWindowFilterType,
                          page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        lastTVShowsTimeWindow = timeWindow
        lastTVShowsPage = page

        guard let tvShows = tvShows else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(tvShows)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func peoplePublisher(timeWindow: TrendingTimeWindowFilterType,
                         page: Int?) -> AnyPublisher<PersonPageableList, TMDbError> {
        lastPeopleTimeWindow = timeWindow
        lastPeoplePage = page

        guard let people = people else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(people)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
#endif

#if swift(>=5.5)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension MockTrendingService {

    func movies(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?) async throws -> MoviePageableList {
        lastMoviesTimeWindow = timeWindow
        lastMoviesPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let movies = self.movies else {
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
                return
            }

            continuation.resume(returning: people)
        }
    }

}
#endif
