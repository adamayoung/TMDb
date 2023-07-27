import Foundation
import os

///
/// Provides an interface for obtaining movies from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class MovieService {

    private static let logger = Logger(subsystem: Logger.tmdb, category: "MovieService")

    private let apiClient: APIClient
    private let localeProvider: () -> Locale

    ///
    /// Creates a movie service object.
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
    /// Returns the primary information about a movie.
    ///
    /// [TMDb API - Movie: Details](https://developers.themoviedb.org/3/movies/get-movie-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the movie.
    ///
    /// - Returns: The matching movie.
    /// 
    public func details(forMovie id: Movie.ID) async throws -> Movie {
        Self.logger.trace("fetching movie \(id, privacy: .public)")

        let movie: Movie
        do {
            movie = try await apiClient.get(endpoint: MoviesEndpoint.details(movieID: id))
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching movie \(id, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return movie
    }

    ///
    /// Returns the cast and crew of a movie.
    ///
    /// [TMDb API - Movie: Credits](https://developers.themoviedb.org/3/movies/get-movie-credits)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///
    /// - Returns: Credits for the matching movie.
    /// 
    public func credits(forMovie movieID: Movie.ID) async throws -> ShowCredits {
        Self.logger.trace("fetching credits for movie \(movieID, privacy: .public)")

        let credits: ShowCredits
        do {
            credits = try await apiClient.get(endpoint: MoviesEndpoint.credits(movieID: movieID))
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching credits for movie \(movieID, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return credits
    }

    ///
    /// Returns the user reviews for a movie.
    ///
    /// [TMDb API - Movie: Reviews](https://developers.themoviedb.org/3/movies/get-movie-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - page: The page of results to return.
    ///
    /// - Returns: Reviews for the matching movie as a pageable list.
    /// 
    public func reviews(forMovie movieID: Movie.ID, page: Int? = nil) async throws -> ReviewPageableList {
        Self.logger.trace("fetching reviews for movie \(movieID, privacy: .public)")

        let reviewList: ReviewPageableList
        do {
            reviewList = try await apiClient.get(endpoint: MoviesEndpoint.reviews(movieID: movieID, page: page))
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching reviews for movie \(movieID, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return reviewList
    }

    ///
    /// Returns the images that belong to a movie.
    ///
    /// [TMDb API - Movie: Images](https://developers.themoviedb.org/3/movies/get-movie-images)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///
    /// - Returns: Collection of images for the matching movie.
    /// 
    public func images(forMovie movieID: Movie.ID) async throws -> ImageCollection {
        Self.logger.trace("fetching images for movie \(movieID, privacy: .public)")

        let languageCode = localeProvider().languageCode
        let imageCollection: ImageCollection
        do {
            imageCollection = try await apiClient.get(
                endpoint: MoviesEndpoint.images(movieID: movieID, languageCode: languageCode)
            )
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching images for movie \(movieID, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return imageCollection
    }

    ///
    /// Returns the videos that have been added to a movie.
    ///
    /// [TMDb API - Movie: Videos](https://developers.themoviedb.org/3/movies/get-movie-videos)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///
    /// - Returns: Collection of videos for the matching movie.
    ///
    public func videos(forMovie movieID: Movie.ID) async throws -> VideoCollection {
        Self.logger.trace("fetching videos for movie \(movieID, privacy: .public)")

        let languageCode = localeProvider().languageCode
        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.get(
                endpoint: MoviesEndpoint.videos(movieID: movieID, languageCode: languageCode)
            )
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching videos for movie \(movieID, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return videoCollection
    }

    ///
    /// Returns a list of recommended movies for a movie.
    ///
    /// [TMDb API - Movie: Recommendations](https://developers.themoviedb.org/3/movies/get-movie-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie for get recommendations for.
    ///    - page: The page of results to return.
    ///
    /// - Returns: Recommended movies for the matching movie as a pageable list.
    /// 
    public func recommendations(forMovie movieID: Movie.ID, page: Int? = nil) async throws -> MoviePageableList {
        Self.logger.trace("fetching recommendations for movie \(movieID, privacy: .public)")

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: MoviesEndpoint.recommendations(movieID: movieID, page: page))
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching recommendations for movie \(movieID, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return movieList
    }

    ///
    /// Returns a list of similar movies for a movie.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - Movie: Similar](https://developers.themoviedb.org/3/movies/get-similar-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie for get similar movies for.
    ///    - page: The page of results to return.
    ///
    /// - Returns: Similar movies for the matching movie as a pageable list.
    /// 
    public func similar(toMovie movieID: Movie.ID, page: Int? = nil) async throws -> MoviePageableList {
        Self.logger.trace("fetching movies similar to movie \(movieID, privacy: .public)")

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: MoviesEndpoint.similar(movieID: movieID, page: page))
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching movies similar for movie \(movieID, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return movieList
    }

    ///
    /// Returns a list of currently playing movies.
    ///
    /// [TMDb API - Movie: Now Playing](https://developers.themoviedb.org/3/movies/get-now-playing)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///
    /// - Returns: Current popular movies as a pageable list.
    /// 
    public func nowPlaying(page: Int? = nil) async throws -> MoviePageableList {
        Self.logger.trace("fetching movies now playing")

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: MoviesEndpoint.nowPlaying(page: page))
        } catch let error {
            Self.logger.error("failed fetching movies now playing")
            throw error
        }

        return movieList
    }

    ///
    /// Returns a list of current popular movies.
    ///
    /// [TMDb API - Movie: Popular](https://developers.themoviedb.org/3/movies/get-popular-movies)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///
    /// - Returns: Current popular movies as a pageable list.
    /// 
    public func popular(page: Int? = nil) async throws -> MoviePageableList {
        Self.logger.trace("fetching popular movies")

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: MoviesEndpoint.popular(page: page))
        } catch let error {
            Self.logger.error("failed fetching popular movies")
            throw error
        }

        return movieList
    }

    ///
    /// Returns a list of top rated movies.
    ///
    /// [TMDb API - Movie: Top Rated](https://developers.themoviedb.org/3/movies/get-top-rated-movies)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///
    /// - Returns: Current popular movies as a pageable list.
    /// 
    public func topRated(page: Int? = nil) async throws -> MoviePageableList {
        Self.logger.trace("fetching top rated movies")

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: MoviesEndpoint.topRated(page: page))
        } catch let error {
            Self.logger.error("failed fetching top rated movies")
            throw error
        }

        return movieList
    }

    ///
    /// Returns a list of upcoming movies.
    ///
    /// [TMDb API - Movie: Upcoming](https://developers.themoviedb.org/3/movies/get-upcoming)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///
    /// - Returns: Current popular movies as a pageable list.
    /// 
    public func upcoming(page: Int? = nil) async throws -> MoviePageableList {
        Self.logger.trace("fetching upcoming movies")

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: MoviesEndpoint.upcoming(page: page))
        } catch let error {
            Self.logger.error("failed fetching upcoming movies")
            throw error
        }

        return movieList
    }

}
