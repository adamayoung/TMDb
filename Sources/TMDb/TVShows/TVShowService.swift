import Foundation
import os

///
/// Provides an interface for obtaining TV shows from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class TVShowService {

    private static let logger = Logger(subsystem: Logger.tmdb, category: "TVShowService")

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
        Self.logger.info("fetching TV show \(id, privacy: .public)")

        let tvShow: TVShow
        do {
            tvShow = try await apiClient.get(endpoint: TVShowsEndpoint.details(tvShowID: id))
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching TV show \(id, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return tvShow
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
        Self.logger.info("fetching credits for TV show \(tvShowID, privacy: .public)")

        let credits: ShowCredits
        do {
            credits = try await apiClient.get(endpoint: TVShowsEndpoint.credits(tvShowID: tvShowID))
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching credits for TV show \(tvShowID, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return credits
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
        Self.logger.info("fetching reviews for TV show \(tvShowID, privacy: .public)")

        let reviewList: ReviewPageableList
        do {
            reviewList = try await apiClient.get(endpoint: TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page))
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching reviews for TV show \(tvShowID, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return reviewList
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
        Self.logger.info("fetching images for TV show \(tvShowID, privacy: .public)")

        let languageCode = localeProvider().languageCode
        let imageCollection: ImageCollection
        do {
            imageCollection = try await apiClient.get(
                endpoint: TVShowsEndpoint.images(tvShowID: tvShowID, languageCode: languageCode)
            )
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching images for TV show \(tvShowID, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return imageCollection
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
        Self.logger.info("fetching videos for TV show \(tvShowID, privacy: .public)")

        let languageCode = localeProvider().languageCode
        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.get(
                endpoint: TVShowsEndpoint.videos(tvShowID: tvShowID, languageCode: languageCode)
            )
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching images for TV show \(tvShowID, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return videoCollection
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
        Self.logger.info("fetching recommendations for TV show \(tvShowID, privacy: .public)")

        let tvShowList: TVShowPageableList
        do {
            tvShowList = try await apiClient.get(
                endpoint: TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page)
            )
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching recommendations for TV show \(tvShowID, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return tvShowList
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
        Self.logger.info("fetching similar TV shows to TV show \(tvShowID, privacy: .public)")

        let tvShowList: TVShowPageableList
        do {
            tvShowList = try await apiClient.get(endpoint: TVShowsEndpoint.similar(tvShowID: tvShowID, page: page))
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching similar TV shows to TV show \(tvShowID, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return tvShowList
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
        Self.logger.info("fetching popular TV shows")

        let tvShowList: TVShowPageableList
        do {
            tvShowList = try await apiClient.get(endpoint: TVShowsEndpoint.popular(page: page))
        } catch let error {
            Self.logger.error("failed fetching popular TV shows: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return tvShowList
    }

}
