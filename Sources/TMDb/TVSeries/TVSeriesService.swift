import Foundation

///
/// Provides an interface for obtaining TV series from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class TVSeriesService {

    private let apiClient: APIClient
    private let localeProvider: () -> Locale

    ///
    /// Creates a TV series service object.
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
    /// Returns the primary information about a TV series.
    ///
    /// [TMDb API - TV Series: Details](https://developer.themoviedb.org/reference/tv-series-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV series.
    ///
    public func details(forTVSeries id: TVSeries.ID) async throws -> TVSeries {
        let tvSeries: TVSeries
        do {
            tvSeries = try await apiClient.get(endpoint: TVSeriesEndpoint.details(tvSeriesID: id))
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeries
    }

    ///
    /// Returns the cast and crew of a TV series.
    ///
    /// [TMDb API - TV Series: Credits](https://developer.themoviedb.org/reference/tv-series-credits)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV series.
    /// 
    public func credits(forTVSeries tvSeriesID: TVSeries.ID) async throws -> ShowCredits {
        let credits: ShowCredits
        do {
            credits = try await apiClient.get(endpoint: TVSeriesEndpoint.credits(tvSeriesID: tvSeriesID))
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    ///
    /// Returns the user reviews for a TV series.
    ///
    /// [TMDb API - TV Series: Reviews](https://developer.themoviedb.org/reference/tv-series-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching TV series as a pageable list.
    /// 
    public func reviews(forTVSeries tvSeriesID: TVSeries.ID, page: Int? = nil) async throws -> ReviewPageableList {
        let reviewList: ReviewPageableList
        do {
            reviewList = try await apiClient.get(endpoint: TVSeriesEndpoint.reviews(tvSeriesID: tvSeriesID, page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return reviewList
    }

    ///
    /// Returns the images that belong to a TV series.
    ///
    /// [TMDb API - TV Series: Images](https://developer.themoviedb.org/reference/tv-series-images)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of images for the matching TV series.
    ///
    public func images(forTVSeries tvSeriesID: TVSeries.ID) async throws -> ImageCollection {
        let languageCode = localeProvider().languageCode
        let imageCollection: ImageCollection
        do {
            imageCollection = try await apiClient.get(
                endpoint: TVSeriesEndpoint.images(tvSeriesID: tvSeriesID, languageCode: languageCode)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    ///
    /// Returns the videos that belong to a TV series.
    ///
    /// [TMDb API - TV Series: Videos](https://developer.themoviedb.org/reference/tv-series-videos)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of videos for the matching TV series.
    ///
    public func videos(forTVSeries tvSeriesID: TVSeries.ID) async throws -> VideoCollection {
        let languageCode = localeProvider().languageCode
        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.get(
                endpoint: TVSeriesEndpoint.videos(tvSeriesID: tvSeriesID, languageCode: languageCode)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return videoCollection
    }

    ///
    /// Returns a list of recommended TV series for a TV series.
    ///
    /// [TMDb API - TV Series: Recommendations](https://developer.themoviedb.org/reference/tv-series-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended TV series for the matching TV series as a pageable list.
    ///
    public func recommendations(forTVSeries tvSeriesID: TVSeries.ID,
                                page: Int? = nil) async throws -> TVSeriesPageableList {
        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.get(
                endpoint: TVSeriesEndpoint.recommendations(tvSeriesID: tvSeriesID, page: page)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    ///
    /// Returns a list of similar TV series for a TV series.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - TV Series: Similar](https://developer.themoviedb.org/reference/tv-series-similar)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series for get similar TV series for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar TV series for the matching TV series as a pageable list.
    /// 
    public func similar(toTVSeries tvSeriesID: TVSeries.ID, page: Int? = nil) async throws -> TVSeriesPageableList {
        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.get(
                endpoint: TVSeriesEndpoint.similar(tvSeriesID: tvSeriesID, page: page)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    ///
    /// Returns a list current popular TV series.
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
    /// - Returns: Current popular TV series as a pageable list.
    ///
    public func popular(page: Int? = nil) async throws -> TVSeriesPageableList {
        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.get(endpoint: TVSeriesEndpoint.popular(page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }
    
    public func watchProviders(forSeries: TVSeries.ID) async throws -> MovieAvailability {
        let watchRegions: MovieAvailability
        do {
            watchRegions = try await apiClient.get(endpoint: TVSeriesEndpoint.watchProviders(tvSeriesID:  forSeries))
        } catch let error {
            throw TMDbError(error: error)
        }
        return watchRegions
    }

}
