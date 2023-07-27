import Foundation

///
/// Provides an interface for obtaining TV shows from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class TVShowService {

    private let apiClient: APIClient
    private let localeProvider: () -> Locale

    ///
    /// Creates a TV show service object.
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
    /// Returns the primary information about a TV show.
    ///
    /// [TMDb API - TV Shows: Details](https://developers.themoviedb.org/3/tv/get-tv-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV show.
    ///
    /// - Returns: The matching TV show.
    /// 
    public func details(forTVShow id: TVShow.ID) async throws -> TVShow {
        try await apiClient.get(endpoint: TVShowsEndpoint.details(tvShowID: id))
    }

    ///
    /// Returns the cast and crew of a TV show.
    ///
    /// [TMDb API - TV Shows: Credits](https://developers.themoviedb.org/3/tv/get-tv-credits)
    ///
    /// - Parameters:
    ///    - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: Show credits for the matching TV show.
    /// 
    public func credits(forTVShow tvShowID: TVShow.ID) async throws -> ShowCredits {
        try await apiClient.get(endpoint: TVShowsEndpoint.credits(tvShowID: tvShowID))
    }

    ///
    /// Returns the user reviews for a TV show.
    ///
    /// [TMDb API - TV Shows: Reviews](https://developers.themoviedb.org/3/tv/get-tv-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvShowID: The identifier of the TV show.
    ///    - page: The page of results to return.
    ///
    /// - Returns: Reviews for the matching TV show as a pageable list.
    /// 
    public func reviews(forTVShow tvShowID: TVShow.ID, page: Int? = nil) async throws -> ReviewPageableList {
        try await apiClient.get(endpoint: TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page))
    }

    ///
    /// Returns the images that belong to a TV show.
    ///
    /// [TMDb API - TV Shows: Images](https://developers.themoviedb.org/3/tv/get-tv-images)
    ///
    /// - Parameters:
    ///    - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of images for the matching TV show.
    ///
    public func images(forTVShow tvShowID: TVShow.ID) async throws -> ImageCollection {
        let languageCode = localeProvider().languageCode

        return try await apiClient.get(endpoint: TVShowsEndpoint.images(tvShowID: tvShowID, languageCode: languageCode))
    }

    ///
    /// Returns the videos that belong to a TV show.
    ///
    /// [TMDb API - TV Shows: Videos](https://developers.themoviedb.org/3/tv/get-tv-videos)
    ///
    /// - Parameters:
    ///    - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of videos for the matching TV show.
    ///
    public func videos(forTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        let languageCode = localeProvider().languageCode

        return try await apiClient.get(endpoint: TVShowsEndpoint.videos(tvShowID: tvShowID, languageCode: languageCode))
    }

    ///
    /// Returns a list of recommended TV shows for a TV show.
    ///
    /// [TMDb API - TV Shows: Recommendations](https://developers.themoviedb.org/3/tv/get-tv-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvShowID: The identifier of the TV show.
    ///    - page: The page of results to return.
    ///
    /// - Returns: Recommended TV shows for the matching TV show as a pageable list.
    ///
    public func recommendations(forTVShow tvShowID: TVShow.ID, page: Int? = nil) async throws -> TVShowPageableList {
        try await apiClient.get(endpoint: TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page))
    }

    ///
    /// Returns a list of similar TV shows for a TV show.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - TV: Similar](https://developers.themoviedb.org/3/tv/get-tv-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvShowID: The identifier of the TV show for get similar TV shows for.
    ///    - page: The page of results to return.
    ///
    /// - Returns: Similar TV shows for the matching TV show as a pageable list.
    /// 
    public func similar(toTVShow tvShowID: TVShow.ID, page: Int? = nil) async throws -> TVShowPageableList {
        try await apiClient.get(endpoint: TVShowsEndpoint.similar(tvShowID: tvShowID, page: page))
    }

    ///
    /// Returns a list current popular TV shows.
    ///
    /// [TMDb API - TV: Popular](https://developers.themoviedb.org/3/tv/get-popular-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///
    /// - Returns: Current popular TV shows as a pageable list.
    ///
    public func popular(page: Int? = nil) async throws -> TVShowPageableList {
        try await apiClient.get(endpoint: TVShowsEndpoint.popular(page: page))
    }

}
