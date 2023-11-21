import Foundation

///
/// Provides an interface for obtaining TV episodes from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class TVEpisodeService {

    private let apiClient: APIClient
    private let localeProvider: () -> Locale

    ///
    /// Creates a TV episode service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient,
            localeProvider: TMDbFactory.localeProvider
        )
    }

    init(apiClient: APIClient, localeProvider: @escaping () -> Locale) {
        self.apiClient = apiClient
        self.localeProvider = localeProvider
    }

    ///
    /// Returns the primary information about a TV episode.
    ///
    /// [TMDb API - TV Episodes: Details](https://developer.themoviedb.org/reference/tv-episode-details)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV series.
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A episode of the matching TV series.
    ///
    public func details(forEpisode episodeNumber: Int, inSeason seasonNumber: Int,
                        inTVSeries tvSeriesID: TVSeries.ID) async throws -> TVEpisode {
        let episode: TVEpisode
        do {
            episode = try await apiClient.get(
                endpoint: TVEpisodesEndpoint.details(
                    tvSeriesID: tvSeriesID,
                    seasonNumber: seasonNumber,
                    episodeNumber: episodeNumber
                )
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return episode
    }

    ///
    /// Returns the images that belong to a TV episode.
    ///
    /// [TMDb API - TV Episode: Images](https://developer.themoviedb.org/reference/tv-episode-images)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV.
    ///    - seasonNumber: The season number of a TV.
    ///    - tvSeriesID: The identifier of the TV.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of images for the matching TV's episode.
    ///
    public func images(forEpisode episodeNumber: Int, inSeason seasonNumber: Int,
                       inTVSeries tvSeriesID: TVSeries.ID) async throws -> TVEpisodeImageCollection {
        let languageCode = localeProvider().languageCode
        let imageCollection: TVEpisodeImageCollection
        do {
            imageCollection = try await apiClient.get(
                endpoint: TVEpisodesEndpoint.images(
                    tvSeriesID: tvSeriesID,
                    seasonNumber: seasonNumber,
                    episodeNumber: episodeNumber,
                    languageCode: languageCode
                )
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    ///
    /// Returns the videos that belong to a TV series episode.
    ///
    /// [TMDb API - TV Episode: Videos](https://developer.themoviedb.org/reference/tv-episode-videos)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV.
    ///    - seasonNumber: The season number of a TV.
    ///    - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of videos for the matching TV's episode.
    ///
    public func videos(forEpisode episodeNumber: Int, inSeason seasonNumber: Int,
                       inTVSeries tvSeriesID: TVSeries.ID) async throws -> VideoCollection {
        let languageCode = localeProvider().languageCode
        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.get(
                endpoint: TVEpisodesEndpoint.videos(
                    tvSeriesID: tvSeriesID,
                    seasonNumber: seasonNumber,
                    episodeNumber: episodeNumber,
                    languageCode: languageCode
                )
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return videoCollection
    }

}
