import Foundation

public final class TVShowEpisodeService {

    private let apiClient: APIClient

    public convenience init(config: TMDbConfiguration) {
        self.init(
            apiClient: TMDbFactory.apiClient(apiKey: config.apiKey)
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns the primary information about a TV show episode.
    ///
    /// [TMDb API - TV Show Episodes: Details](https://developers.themoviedb.org/3/tv-episodes/get-tv-episode-details)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV show.
    ///    - seasonNumber: The season number of a TV show.
    ///    - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A episode of the matching TV show.
    /// 
    public func details(forEpisode episodeNumber: Int, inSeason seasonNumber: Int,
                        inTVShow tvShowID: TVShow.ID) async throws -> TVShowEpisode {
        try await apiClient.get(
            endpoint: TVShowEpisodesEndpoint.details(
                tvShowID: tvShowID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber
            )
        )
    }

    ///
    /// Returns the images that belong to a TV show episode.
    ///
    /// [TMDb API - TV Show Episode: Images](https://developers.themoviedb.org/3/tv-episodes/get-tv-episode-images)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV show.
    ///    - seasonNumber: The season number of a TV show.
    ///    - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of images for the matching TV show's episode.
    ///
    public func images(forEpisode episodeNumber: Int, inSeason seasonNumber: Int,
                       inTVShow tvShowID: TVShow.ID) async throws -> TVShowEpisodeImageCollection {
        try await apiClient.get(
            endpoint: TVShowEpisodesEndpoint.images(
                tvShowID: tvShowID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber
            )
        )
    }

    ///
    /// Returns the videos that belong to a TV show episode.
    ///
    /// [TMDb API - TV Show Episode: Videos](https://developers.themoviedb.org/3/tv-episodes/get-tv-episode-videos)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV show.
    ///    - seasonNumber: The season number of a TV show.
    ///    - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of videos for the matching TV show's episode.
    ///
    public func videos(forEpisode episodeNumber: Int, inSeason seasonNumber: Int,
                       inTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        try await apiClient.get(
            endpoint: TVShowEpisodesEndpoint.videos(
                tvShowID: tvShowID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber
            )
        )
    }

}
