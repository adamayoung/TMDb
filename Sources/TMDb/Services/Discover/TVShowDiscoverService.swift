import Foundation

/// A service to discover TV shows by different types of data like average rating, number of votes, genres and certifications.
public protocol TVShowDiscoverService {

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

public extension TVShowDiscoverService {

    func tvShows(sortedBy: TVShowSort? = nil, page: Int? = nil) async throws -> TVShowPageableList {
        try await tvShows(sortedBy: sortedBy, page: page)
    }

}
