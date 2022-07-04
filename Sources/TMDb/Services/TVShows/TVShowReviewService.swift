import Foundation

/// A service to fetch reviews for a TV show.
public protocol TVShowReviewService {

    /// Returns the user reviews for a TV show.
    ///
    /// [TMDb API - TV Shows: Reviews](https://developers.themoviedb.org/3/tv/get-tv-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Reviews for the matching TV show as a pageable list.
    func reviews(forTVShow tvShowID: TVShow.ID, page: Int?) async throws -> ReviewPageableList

}

public extension TVShowReviewService {

    func reviews(forTVShow tvShowID: TVShow.ID, page: Int? = nil) async throws -> ReviewPageableList {
        try await reviews(forTVShow: tvShowID, page: page)
    }

}
