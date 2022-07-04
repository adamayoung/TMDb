import Foundation

/// A service to fetch details of a TV show season.
public protocol TVShowSeasonDetailsService {

    /// Returns the primary information about a TV show season.
    ///
    /// [TMDb API - TV Show Seasons: Details](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-details)
    ///
    /// - Parameters:
    ///     - seasonNumber: The season number of a TV show.
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A season of the matching TV show.
    func details(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> TVShowSeason

}
