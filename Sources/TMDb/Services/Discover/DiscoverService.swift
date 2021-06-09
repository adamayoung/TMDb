import Foundation

#if canImport(Combine)
import Combine
#endif

/// Discovery interface.
public protocol DiscoverService {

    /// Fetches movies to be discovered.
    ///
    /// - Note: [TMDb API - Discover: Movies](https://developers.themoviedb.org/3/discover/movie-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortedBy: How results should be sorted.
    ///     - people: A list of Person identifiers which to return only movies they have appeared in.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Matching movies as a pageable list.
    func fetchMovies(sortedBy: MovieSort?, withPeople people: [Person.ID]?, page: Int?,
                     completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void)

    /// Fetches TV shows to be discovered.
    ///
    /// - Note: [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortedBy: How results should be sorted.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Matching TV shows as a pageable list.
    func fetchTVShows(sortedBy: TVShowSort?, page: Int?,
                      completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void)

    #if canImport(Combine)
    /// Publishes movies to be discovered.
    ///
    /// - Note: [TMDb API - Discover: Movies](https://developers.themoviedb.org/3/discover/movie-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortedBy: How results should be sorted.
    ///     - people: A list of Person identifiers which to return only movies they have appeared in.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with the matching movies as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func moviesPublisher(sortedBy: MovieSort?, withPeople people: [Person.ID]?,
                         page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    /// Publishes TV shows to be discovered.
    ///
    /// - Note: [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortedBy: How results should be sorted.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with the matching TV shows as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func tvShowsPublisher(sortedBy: TVShowSort?, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>
    #endif

}

public extension DiscoverService {

    func fetchMovies(sortedBy: MovieSort? = nil, withPeople people: [Person.ID]? = nil, page: Int? = nil,
                     completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void) {
        fetchMovies(sortedBy: sortedBy, withPeople: people, page: page, completion: completion)
    }

    func fetchTVShows(sortedBy: TVShowSort? = nil, page: Int? = nil,
                      completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void) {
        fetchTVShows(sortedBy: sortedBy, page: page, completion: completion)
    }

}

#if canImport(Combine)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension DiscoverService {

    func moviesPublisher(sortedBy: MovieSort? = nil, withPeople people: [Person.ID]? = nil,
                         page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        moviesPublisher(sortedBy: sortedBy, withPeople: people, page: page)
    }

    func tvShowsPublisher(sortedBy: TVShowSort? = nil,
                          page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        tvShowsPublisher(sortedBy: sortedBy, page: page)
    }

}
#endif

#if swift(>=5.5)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension DiscoverService {

    /// Returns movies to be discovered.
    ///
    /// - Note: [TMDb API - Discover: Movies](https://developers.themoviedb.org/3/discover/movie-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortedBy: How results should be sorted.
    ///     - people: A list of Person identifiers which to return only movies they have appeared in.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Matching movies as a pageable list.
    func movies(sortedBy: MovieSort? = nil, withPeople people: [Person.ID]? = nil,
                page: Int? = nil) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchMovies(sortedBy: sortedBy, withPeople: people, page: page, completion: continuation.resume(with:))
        }
    }

    /// Returns TV shows to be discovered.
    ///
    /// - Note: [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortedBy: How results should be sorted.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Matching TV shows as a pageable list.
    func tvShows(sortedBy: TVShowSort? = nil, page: Int? = nil) async throws -> TVShowPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchTVShows(sortedBy: sortedBy, page: page, completion: continuation.resume(with:))
        }
    }

}
#endif
