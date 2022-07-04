import Foundation

/// A service to fetch credits for a TV show.
public protocol TVShowCreditsService {

    /// Returns the cast and crew of a TV show.
    ///
    /// [TMDb API - TV Shows: Credits](https://developers.themoviedb.org/3/tv/get-tv-credits)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: Show credits for the matching TV show.
    func credits(forTVShow tvShowID: TVShow.ID) async throws -> ShowCredits

}
