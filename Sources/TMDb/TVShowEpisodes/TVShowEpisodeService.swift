import Foundation
import os

///
/// Provides an interface for obtaining TV show episodes from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class TVShowEpisodeService {

    private static let logger = Logger(subsystem: Logger.tmdb, category: "TVShowEpisodeService")

    private let apiClient: APIClient

    ///
    /// Creates a TV show episode service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
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
        // swiftlint:disable:next line_length
        Self.logger.trace("fetching TV show episode \(episodeNumber, privacy: .public) in season \(seasonNumber, privacy: .public) in TV show \(tvShowID, privacy: .public)")

        let episode: TVShowEpisode
        do {
            episode = try await apiClient.get(
                endpoint: TVShowEpisodesEndpoint.details(
                    tvShowID: tvShowID,
                    seasonNumber: seasonNumber,
                    episodeNumber: episodeNumber
                )
            )
        } catch let error {
            Self.logger.error("failed fetching TV show episode: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return episode
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
        // swiftlint:disable:next line_length
        Self.logger.trace("fetching images for TV show episode \(episodeNumber, privacy: .public) in season \(seasonNumber, privacy: .public) in TV show \(tvShowID, privacy: .public)")

        let imageCollection: TVShowEpisodeImageCollection
        do {
            imageCollection = try await apiClient.get(
                endpoint: TVShowEpisodesEndpoint.images(
                    tvShowID: tvShowID,
                    seasonNumber: seasonNumber,
                    episodeNumber: episodeNumber
                )
            )
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching images for TV show episode: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return imageCollection
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
        // swiftlint:disable:next line_length
        Self.logger.trace("fetching videos for TV show episode \(episodeNumber, privacy: .public) in season \(seasonNumber, privacy: .public) in TV show \(tvShowID, privacy: .public)")

        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.get(
                endpoint: TVShowEpisodesEndpoint.videos(
                    tvShowID: tvShowID,
                    seasonNumber: seasonNumber,
                    episodeNumber: episodeNumber
                )
            )
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching videos for TV show episode: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return videoCollection
    }

}
