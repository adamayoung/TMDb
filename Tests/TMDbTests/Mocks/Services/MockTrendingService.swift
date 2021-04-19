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
