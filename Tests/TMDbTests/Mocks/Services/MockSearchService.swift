@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

final class MockSearchService: SearchService {

    var media: MediaPageableList?
    private(set) var lastSearchAllQuery: String?
    private(set) var lastSearchAllPage: Int?
    var movies: MoviePageableList?
    private(set) var lastSearchMoviesQuery: String?
    private(set) var lastSearchMoviesYear: Int?
    private(set) var lastSearchMoviesPage: Int?
    var tvShows: TVShowPageableList?
    private(set) var lastSearchTVShowsQuery: String?
    private(set) var lastSearchTVShowsFirstAirDateYear: Int?
    private(set) var lastSearchTVShowsPage: Int?
    var people: PersonPageableList?
    private(set) var lastSearchPeopleQuery: String?
    private(set) var lastSearchPeoplePage: Int?

    func searchAll(query: String, page: Int?, completion: @escaping (Result<MediaPageableList, TMDbError>) -> Void) {
        lastSearchAllQuery = query
        lastSearchAllPage = page

        guard let media = media else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(media))
        }
    }

    func searchMovies(query: String, year: Int?, page: Int?,
                      completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        lastSearchMoviesQuery = query
        lastSearchMoviesYear = year
        lastSearchMoviesPage = page

        guard let movies = movies else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(movies))
        }
    }

    func searchTVShows(query: String, firstAirDateYear: Int?, page: Int?,
                       completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        lastSearchTVShowsQuery = query
        lastSearchTVShowsFirstAirDateYear = firstAirDateYear
        lastSearchTVShowsPage = page

        guard let tvShows = tvShows else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(tvShows))
        }
    }

    func searchPeople(query: String, page: Int?,
                      completion: @escaping (Result<PersonPageableList, TMDbError>) -> Void) {
        lastSearchPeopleQuery = query
        lastSearchPeoplePage = page

        guard let people = people else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(people))
        }
    }

}

#if canImport(Combine)
extension MockSearchService {

    func searchAllPublisher(query: String, page: Int?) -> AnyPublisher<MediaPageableList, TMDbError> {
        lastSearchAllQuery = query
        lastSearchAllPage = page

        guard let media = media else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(media)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func searchMoviesPublisher(query: String, year: Int?, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        lastSearchMoviesQuery = query
        lastSearchMoviesYear = year
        lastSearchMoviesPage = page

        guard let movies = movies else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(movies)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func searchTVShowsPublisher(query: String, firstAirDateYear: Int?,
                                page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        lastSearchTVShowsQuery = query
        lastSearchTVShowsFirstAirDateYear = firstAirDateYear
        lastSearchTVShowsPage = page

        guard let tvShows = tvShows else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(tvShows)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func searchPeoplePublisher(query: String, page: Int?) -> AnyPublisher<PersonPageableList, TMDbError> {
        lastSearchPeopleQuery = query
        lastSearchPeoplePage = page

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
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension MockSearchService {

    func searchAll(query: String, page: Int?) async throws -> MediaPageableList {
        lastSearchAllQuery = query
        lastSearchAllPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let media = self.media else {
                return
            }

            continuation.resume(returning: media)
        }
    }

    func searchMovies(query: String, year: Int?, page: Int?) async throws -> MoviePageableList {
        lastSearchMoviesQuery = query
        lastSearchMoviesYear = year
        lastSearchMoviesPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let movies = self.movies else {
                return
            }

            continuation.resume(returning: movies)
        }
    }

    func searchTVShows(query: String, firstAirDateYear: Int?, page: Int?) async throws -> TVShowPageableList {
        lastSearchTVShowsQuery = query
        lastSearchTVShowsFirstAirDateYear = firstAirDateYear
        lastSearchTVShowsPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let tvShows = self.tvShows else {
                return
            }

            continuation.resume(returning: tvShows)
        }
    }

    func searchPeople(query: String, page: Int?) async throws -> PersonPageableList {
        lastSearchPeopleQuery = query
        lastSearchPeoplePage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let people = self.people else {
                return
            }

            continuation.resume(returning: people)
        }
    }

}
#endif
