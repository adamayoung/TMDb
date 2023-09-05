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
    /// [TMDb API - TV Series: Details](https://developer.themoviedb.org/reference/tv-series-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV show.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV show.
    /// 
    public func details(forTVShow id: TVShow.ID) async throws -> TVShow {
        let tvShow: TVShow
        do {
            tvShow = try await apiClient.get(endpoint: TVShowsEndpoint.details(tvShowID: id))
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvShow
    }

    ///
    /// Returns the cast and crew of a TV show.
    ///
    /// [TMDb API - TV Series: Credits](https://developer.themoviedb.org/reference/tv-series-credits)
    ///
    /// - Parameters:
    ///    - tvShowID: The identifier of the TV show.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV show.
    /// 
    public func credits(forTVShow tvShowID: TVShow.ID) async throws -> ShowCredits {
        let credits: ShowCredits
        do {
            credits = try await apiClient.get(endpoint: TVShowsEndpoint.credits(tvShowID: tvShowID))
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    ///
    /// Returns the user reviews for a TV show.
    ///
    /// [TMDb API - TV Series: Reviews](https://developer.themoviedb.org/reference/tv-series-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvShowID: The identifier of the TV show.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching TV show as a pageable list.
    /// 
    public func reviews(forTVShow tvShowID: TVShow.ID, page: Int? = nil) async throws -> ReviewPageableList {
        let reviewList: ReviewPageableList
        do {
            reviewList = try await apiClient.get(endpoint: TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return reviewList
    }

    ///
    /// Returns the images that belong to a TV show.
    ///
    /// [TMDb API - TV Series: Images](https://developer.themoviedb.org/reference/tv-series-images)
    ///
    /// - Parameters:
    ///    - tvShowID: The identifier of the TV show.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of images for the matching TV show.
    ///
    public func images(forTVShow tvShowID: TVShow.ID) async throws -> ImageCollection {
        let languageCode = localeProvider().languageCode
        let imageCollection: ImageCollection
        do {
            imageCollection = try await apiClient.get(
                endpoint: TVShowsEndpoint.images(tvShowID: tvShowID, languageCode: languageCode)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    ///
    /// Returns the videos that belong to a TV show.
    ///
    /// [TMDb API - TV Series: Videos](https://developer.themoviedb.org/reference/tv-series-videos)
    ///
    /// - Parameters:
    ///    - tvShowID: The identifier of the TV show.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of videos for the matching TV show.
    ///
    public func videos(forTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        let languageCode = localeProvider().languageCode
        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.get(
                endpoint: TVShowsEndpoint.videos(tvShowID: tvShowID, languageCode: languageCode)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return videoCollection
    }

    ///
    /// Returns a list of recommended TV shows for a TV show.
    ///
    /// [TMDb API - TV Series: Recommendations](https://developer.themoviedb.org/reference/tv-series-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvShowID: The identifier of the TV show.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended TV shows for the matching TV show as a pageable list.
    ///
    public func recommendations(forTVShow tvShowID: TVShow.ID, page: Int? = nil) async throws -> TVShowPageableList {
        let tvShowList: TVShowPageableList
        do {
            tvShowList = try await apiClient.get(
                endpoint: TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvShowList
    }

    ///
    /// Returns a list of similar TV shows for a TV show.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - TV Series: Similar](https://developer.themoviedb.org/reference/tv-series-similar)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvShowID: The identifier of the TV show for get similar TV shows for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar TV shows for the matching TV show as a pageable list.
    /// 
    public func similar(toTVShow tvShowID: TVShow.ID, page: Int? = nil) async throws -> TVShowPageableList {
        let tvShowList: TVShowPageableList
        do {
            tvShowList = try await apiClient.get(endpoint: TVShowsEndpoint.similar(tvShowID: tvShowID, page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvShowList
    }

    ///
    /// Returns a list current popular TV shows.
    ///
    /// [TMDb API - TV Series Lists: Popular](https://developer.themoviedb.org/reference/tv-series-popular-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular TV shows as a pageable list.
    ///
    public func popular(page: Int? = nil) async throws -> TVShowPageableList {
        let tvShowList: TVShowPageableList
        do {
            tvShowList = try await apiClient.get(endpoint: TVShowsEndpoint.popular(page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvShowList
    }

}
