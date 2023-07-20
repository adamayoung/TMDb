import Foundation

///
/// Provides an interface for obtaining TV shows from TMDb.
///
public final class TVShowService {

    private let apiClient: APIClient

    ///
    /// Creates a TV show service object.
    ///
    /// - Parameters:
    ///    - config: TMDb configuration setting.
    ///
    public convenience init(config: TMDbConfiguration) {
        self.init(
            apiClient: TMDbFactory.apiClient(apiKey: config.apiKey)
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
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
        try await apiClient.get(endpoint: TVShowsEndpoint.images(tvShowID: tvShowID))
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
        try await apiClient.get(endpoint: TVShowsEndpoint.videos(tvShowID: tvShowID))
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
