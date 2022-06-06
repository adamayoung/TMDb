import Foundation

/// Discover movies by different types of data like average rating, number of votes, genres and certifications.
public protocol DiscoverService {

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
    func movies(sortedBy: MovieSort?, withPeople people: [Person.ID]?, page: Int?) async throws -> MoviePageableList

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
    func tvShows(sortedBy: TVShowSort?, page: Int?) async throws -> TVShowPageableList

}

public extension DiscoverService {

    func movies(sortedBy: MovieSort? = nil, withPeople people: [Person.ID]? = nil,
                page: Int? = nil) async throws -> MoviePageableList {
        try await movies(sortedBy: sortedBy, withPeople: people, page: page)
    }

    func tvShows(sortedBy: TVShowSort? = nil, page: Int? = nil) async throws -> TVShowPageableList {
        try await tvShows(sortedBy: sortedBy, page: page)
    }

}
