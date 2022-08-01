import Foundation

/// A service to fetch details of a TV show episode.
public protocol TVShowEpisodeDetailsService {

    /// Returns the primary information about a TV show episode.
    ///
    /// [TMDb API - TV Show Episodes: Details](https://developers.themoviedb.org/3/tv-episodes/get-tv-episode-details)
    ///
    /// - Parameters:
    ///     - episodeNumber: The episode number of a TV show.
    ///     - seasonNumber: The season number of a TV show.
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A episode of the matching TV show.
    func details(forEpisode episodeNumber: Int, inSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> TVShowEpisode

}