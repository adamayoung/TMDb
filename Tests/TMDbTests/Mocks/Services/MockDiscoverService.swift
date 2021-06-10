@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

final class MockDiscoverService: DiscoverService {

    var movies: MoviePageableList?
    private(set) var lastMoviesSortBy: MovieSort?
    private(set) var lastMoviesWithPeople: [Person.ID]?
    private(set) var lastMoviesPage: Int?
    var tvShows: TVShowPageableList?
    private(set) var lastTVShowsSortBy: TVShowSort?
    private(set) var lastTVShowsPage: Int?

    func fetchMovies(sortBy: MovieSort?, withPeople people: [Person.ID]?, page: Int?,
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

    func fetchTVShows(sortBy: TVShowSort?, page: Int?,
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

    func moviesPublisher(sortBy: MovieSort?, withPeople people: [Person.ID]?,
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

    func tvShowsPublisher(sortBy: TVShowSort?, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
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
