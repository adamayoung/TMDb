import Foundation

/// A service to fetch details of a TV show.
public protocol TVShowDetailsService {

    /// Returns the primary information about a TV show.
    ///
    /// [TMDb API - TV Shows: Details](https://developers.themoviedb.org/3/tv/get-tv-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the TV show.
    ///
    /// - Returns: The matching TV show.
    func details(forTVShow id: TVShow.ID) async throws -> TVShow

}
