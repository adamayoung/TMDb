import Foundation

/// A service to fetch image and videos for a TV show episode.
public protocol TVShowEpisodeImageryService {

    /// Returns the images that belong to a TV show episode.
    ///
    /// [TMDb API - TV Show Episode: Images](https://developers.themoviedb.org/3/tv-episodes/get-tv-episode-images)
    ///
    /// - Parameters:
    ///     - episodeNumber: The episode number of a TV show.
    ///     - seasonNumber: The season number of a TV show.
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of images for the matching TV show's episode.
    func images(forEpisode episodeNumber: Int, inSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> TVShowEpisodeImageCollection

    /// Returns the videos that belong to a TV show episode.
    ///
    /// [TMDb API - TV Show Episode: Videos](https://developers.themoviedb.org/3/tv-episodes/get-tv-episode-videos)
    ///
    /// - Parameters:
    ///     - episodeNumber: The episode number of a TV show.
    ///     - seasonNumber: The season number of a TV show.
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of videos for the matching TV show's episode.
    func videos(forEpisode episodeNumber: Int, inSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> VideoCollection

}