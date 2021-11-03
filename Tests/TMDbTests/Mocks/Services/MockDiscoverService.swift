@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

final class MockDiscoverService: DiscoverService {

    var movies: MoviePageableList?
    private(set) var lastMoviesSortedBy: MovieSort?
    private(set) var lastMoviesWithPeople: [Person.ID]?
    private(set) var lastMoviesPage: Int?

    var tvShows: TVShowPageableList?
    private(set) var lastTVShowsSortedBy: TVShowSort?
    private(set) var lastTVShowsPage: Int?

    func fetchMovies(sortedBy: MovieSort?, withPeople people: [Person.ID]?, page: Int?,
                     completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        lastMoviesSortedBy = sortedBy
        lastMoviesWithPeople = people
        lastMoviesPage = page

        guard let movies = movies else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(movies))
        }
    }

    func fetchTVShows(sortedBy: TVShowSort?, page: Int?,
                      completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        lastTVShowsSortedBy = sortedBy
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

    func moviesPublisher(sortedBy: MovieSort?, withPeople people: [Person.ID]?,
                         page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        lastMoviesSortedBy = sortedBy
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

    func tvShowsPublisher(sortedBy: TVShowSort?, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        lastTVShowsSortedBy = sortedBy
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

#if swift(>=5.5)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension MockDiscoverService {

    func movies(sortedBy: MovieSort?, withPeople people: [Person.ID]?, page: Int?) async throws -> MoviePageableList {
        lastMoviesSortedBy = sortedBy
        lastMoviesWithPeople = people
        lastMoviesPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let movies = self.movies else {
                return
            }

            continuation.resume(returning: movies)
        }
    }

    func tvShows(sortedBy: TVShowSort? = nil, page: Int? = nil) async throws -> TVShowPageableList {
        lastTVShowsSortedBy = sortedBy
        lastTVShowsPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let tvShows = self.tvShows else {
                return
            }

            continuation.resume(returning: tvShows)
        }
    }

}
#endif
