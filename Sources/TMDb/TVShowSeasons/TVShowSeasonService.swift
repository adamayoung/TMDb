import Foundation

///
/// Provides an interface for obtaining TV show seasons from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class TVShowSeasonService {

    private let apiClient: APIClient
    private let localeProvider: () -> Locale

    ///
    /// Creates a TV show season service object.
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
    /// Returns the primary information about a TV show season.
    ///
    /// [TMDb API - TV Show Seasons: Details](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-details)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV show.
    ///    - tvShowID: The identifier of the TV show.
    ///
    /// - Throws: TMDb data error ``TMDbError``.
    ///
    /// - Returns: A season of the matching TV show.
    ///
    public func details(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> TVShowSeason {
        let season: TVShowSeason
        do {
            season = try await apiClient.get(
                endpoint: TVShowSeasonsEndpoint.details(tvShowID: tvShowID, seasonNumber: seasonNumber)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return season
    }

    ///
    /// Returns the images that belong to a TV show season.
    ///
    /// [TMDb API - TV Show Seasons: Images](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-images)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV show.
    ///    - tvShowID: The identifier of the TV show.
    ///
    /// - Throws: TMDb data error ``TMDbError``.
    ///
    /// - Returns: A collection of images for the matching TV show's season.
    ///
    public func images(forSeason seasonNumber: Int,
                       inTVShow tvShowID: TVShow.ID) async throws -> TVShowSeasonImageCollection {
        let languageCode = localeProvider().languageCode
        let imageCollection: TVShowSeasonImageCollection
        do {
            imageCollection = try await apiClient.get(
                endpoint: TVShowSeasonsEndpoint.images(tvShowID: tvShowID, seasonNumber: seasonNumber,
                                                       languageCode: languageCode)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    ///
    /// Returns the videos that belong to a TV show season.
    ///
    /// [TMDb API - TV Show Seasons: Videos](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-videos)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV show.
    ///    - tvShowID: The identifier of the TV show.
    ///
    /// - Throws: TMDb data error ``TMDbError``.
    ///
    /// - Returns: A collection of videos for the matching TV show's season.
    ///
    public func videos(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        let languageCode = localeProvider().languageCode
        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.get(
                endpoint: TVShowSeasonsEndpoint.videos(tvShowID: tvShowID, seasonNumber: seasonNumber,
                                                       languageCode: languageCode)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return videoCollection
    }

}
