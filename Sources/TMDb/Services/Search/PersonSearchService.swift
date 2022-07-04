import Foundation

/// A service to search for people.
public protocol PersonSearchService {

    /// Returns search results for people.
    ///
    /// [TMDb API - Search: People](https://developers.themoviedb.org/3/search/search-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: People matching the query.
    func searchPeople(query: String, page: Int?) async throws -> PersonPageableList

}

public extension PersonSearchService {

    func searchPeople(query: String, page: Int? = nil) async throws -> PersonPageableList {
        try await searchPeople(query: query, page: page)
    }

}
