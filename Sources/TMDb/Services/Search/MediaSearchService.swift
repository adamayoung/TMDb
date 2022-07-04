import Foundation

/// A service to search all media (movies, TV shows and people).
public protocol MediaSearchService {

    /// Returns search results for movies, TV shows and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developers.themoviedb.org/3/search/multi-search)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Movies, TV shows and people matching the query.
    func searchAll(query: String, page: Int?) async throws -> MediaPageableList

}

public extension MediaSearchService {

    func searchAll(query: String, page: Int? = nil) async throws -> MediaPageableList {
        try await searchAll(query: query, page: page)
    }

}
