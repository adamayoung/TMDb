import Foundation

///
/// Provides an interface for obtaining TV seasons from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class TVSeasonService {

    private let apiClient: APIClient
    private let localeProvider: () -> Locale

    ///
    /// Creates a TV season service object.
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
    /// Returns the primary information about a TV season.
    ///
    /// [TMDb API - TV Seasons: Details](https://developer.themoviedb.org/reference/tv-season-details)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A season of the matching TV series.
    ///
    public func details(forSeason seasonNumber: Int, inTVSeries tvSeriesID: TVSeries.ID) async throws -> TVSeason {
        let season: TVSeason
        do {
            season = try await apiClient.get(
                endpoint: TVSeasonsEndpoint.details(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return season
    }

    ///
    /// Returns the images that belong to a TV season.
    ///
    /// [TMDb API - TV Seasons: Images](https://developer.themoviedb.org/reference/tv-season-images)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of images for the matching TV's season.
    ///
    public func images(forSeason seasonNumber: Int,
                       inTVSeries tvSeriesID: TVSeries.ID) async throws -> TVSeasonImageCollection {
        let languageCode = localeProvider().languageCode
        let imageCollection: TVSeasonImageCollection
        do {
            imageCollection = try await apiClient.get(
                endpoint: TVSeasonsEndpoint.images(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber,
                                                   languageCode: languageCode)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    ///
    /// Returns the videos that belong to a TV season.
    ///
    /// [TMDb API - TV Seasons: Videos](https://developer.themoviedb.org/reference/tv-season-videos)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of videos for the matching TV series season.
    ///
    public func videos(forSeason seasonNumber: Int,
                       inTVSeries tvSeriesID: TVSeries.ID) async throws -> VideoCollection {
        let languageCode = localeProvider().languageCode
        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.get(
                endpoint: TVSeasonsEndpoint.videos(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber,
                                                   languageCode: languageCode)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return videoCollection
    }

}
