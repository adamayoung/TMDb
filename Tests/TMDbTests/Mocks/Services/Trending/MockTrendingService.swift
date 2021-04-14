import Combine
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

    func fetchMovies(timeWindow: TrendingTimeWindowFilterType,
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

    func fetchTVShows(timeWindow: TrendingTimeWindowFilterType,
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

    func fetchPeople(timeWindow: TrendingTimeWindowFilterType,
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
