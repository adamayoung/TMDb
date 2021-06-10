import Foundation

#if swift(>=5.5)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension DiscoverService {

    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movies](https://developers.themoviedb.org/3/discover/movie-discover)
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
    /// [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
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
