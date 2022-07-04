import Foundation

/// A service to search for movies.
public protocol MovieSearchService {

    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developers.themoviedb.org/3/search/search-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - year: The year to filter results for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Movies matching the query.
    func searchMovies(query: String, year: Int?, page: Int?) async throws -> MoviePageableList

}

public extension MovieSearchService {

    func searchMovies(query: String, year: Int? = nil, page: Int? = nil) async throws -> MoviePageableList {
        try await searchMovies(query: query, year: year, page: page)
    }

}
