import Foundation

///
/// Provides an interface for obtaining TV show seasons from TMDb.
///
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
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
    /// - Returns: A season of the matching TV show.
    ///
    public func details(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> TVShowSeason {
        try await apiClient.get(endpoint: TVShowSeasonsEndpoint.details(tvShowID: tvShowID, seasonNumber: seasonNumber))
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
    /// - Returns: A collection of images for the matching TV show's season.
    ///
    public func images(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> ImageCollection {
        let languageCode = localeProvider().languageCode

        return try await apiClient.get(
            endpoint: TVShowSeasonsEndpoint.images(tvShowID: tvShowID, seasonNumber: seasonNumber,
                                                   languageCode: languageCode)
        )
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
    /// - Returns: A collection of videos for the matching TV show's season.
    ///
    public func videos(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        let languageCode = localeProvider().languageCode

        return try await apiClient.get(
            endpoint: TVShowSeasonsEndpoint.videos(tvShowID: tvShowID, seasonNumber: seasonNumber,
                                                   languageCode: languageCode)
        )
    }

}
