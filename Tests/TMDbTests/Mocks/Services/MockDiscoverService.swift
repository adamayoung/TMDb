@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

final class MockDiscoverService: DiscoverService {

    var movies: MoviePageableList?
    private(set) var lastMoviesSortBy: MovieSortBy?
    private(set) var lastMoviesWithPeople: [Person.ID]?
    private(set) var lastMoviesPage: Int?
    var tvShows: TVShowPageableList?
    private(set) var lastTVShowsSortBy: TVShowSortBy?
    private(set) var lastTVShowsPage: Int?

    func fetchMovies(sortBy: MovieSortBy?, withPeople people: [Person.ID]?, page: Int?,
                     completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        lastMoviesSortBy = sortBy
        lastMoviesWithPeople = people
        lastMoviesPage = page

        guard let movies = movies else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(movies))
        }
    }

    func fetchTVShows(sortBy: TVShowSortBy?, page: Int?,
                      completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        lastTVShowsSortBy = sortBy
        lastTVShowsPage = page

        guard let tvShows = tvShows else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(tvShows))
        }
    }

}

#if canImport(Combine)
extension MockDiscoverService {

    func moviesPublisher(sortBy: MovieSortBy?, withPeople people: [Person.ID]?,
                         page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        lastMoviesSortBy = sortBy
        lastMoviesWithPeople = people
        lastMoviesPage = page

        guard let movies = movies else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(movies)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func tvShowsPublisher(sortBy: TVShowSortBy?, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        lastTVShowsSortBy = sortBy
        lastTVShowsPage = page

        guard let tvShows = tvShows else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(tvShows)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
#endif
