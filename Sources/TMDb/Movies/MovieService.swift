//
//  MovieService.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// Provides an interface for obtaining movies from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class MovieService {

    private let apiClient: any APIClient
    private let localeProvider: any LocaleProviding

    ///
    /// Creates a movie service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient,
            localeProvider: TMDbFactory.localeProvider()
        )
    }

    init(apiClient: some APIClient, localeProvider: some LocaleProviding) {
        self.apiClient = apiClient
        self.localeProvider = localeProvider
    }

    ///
    /// Returns the primary information about a movie.
    ///
    /// [TMDb API - Movies: Details](https://developer.themoviedb.org/reference/movie-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching movie.
    ///
    public func details(forMovie id: Movie.ID) async throws -> Movie {
        let movie: Movie
        do {
            movie = try await apiClient.get(endpoint: MoviesEndpoint.details(movieID: id))
        } catch let error {
            throw TMDbError(error: error)
        }

        return movie
    }

    ///
    /// Returns the cast and crew of a movie.
    ///
    /// [TMDb API - Movies: Credits](https://developer.themoviedb.org/reference/movie-credits)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Credits for the matching movie.
    ///
    public func credits(forMovie movieID: Movie.ID) async throws -> ShowCredits {
        let credits: ShowCredits
        do {
            credits = try await apiClient.get(endpoint: MoviesEndpoint.credits(movieID: movieID))
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    ///
    /// Returns the user reviews for a movie.
    ///
    /// [TMDb API - Movies: Reviews](https://developer.themoviedb.org/reference/movie-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching movie as a pageable list.
    ///
    public func reviews(forMovie movieID: Movie.ID, page: Int? = nil) async throws -> ReviewPageableList {
        let reviewList: ReviewPageableList
        do {
            reviewList = try await apiClient.get(endpoint: MoviesEndpoint.reviews(movieID: movieID, page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return reviewList
    }

    ///
    /// Returns the images that belong to a movie.
    ///
    /// [TMDb API - Movies: Images](https://developer.themoviedb.org/reference/movie-images)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Collection of images for the matching movie.
    ///
    public func images(forMovie movieID: Movie.ID) async throws -> ImageCollection {
        let languageCode = localeProvider.languageCode
        let imageCollection: ImageCollection
        do {
            imageCollection = try await apiClient.get(
                endpoint: MoviesEndpoint.images(movieID: movieID, languageCode: languageCode)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    ///
    /// Returns the videos that have been added to a movie.
    ///
    /// [TMDb API - Movies: Videos](https://developer.themoviedb.org/reference/movie-videos)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Collection of videos for the matching movie.
    ///
    public func videos(forMovie movieID: Movie.ID) async throws -> VideoCollection {
        let languageCode = localeProvider.languageCode
        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.get(
                endpoint: MoviesEndpoint.videos(movieID: movieID, languageCode: languageCode)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return videoCollection
    }

    ///
    /// Returns a list of recommended movies for a movie.
    ///
    /// [TMDb API - Movies: Recommendations](https://developer.themoviedb.org/reference/movie-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie for get recommendations for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended movies for the matching movie as a pageable list.
    ///
    public func recommendations(forMovie movieID: Movie.ID, page: Int? = nil) async throws -> MoviePageableList {
        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: MoviesEndpoint.recommendations(movieID: movieID, page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    ///
    /// Returns a list of similar movies for a movie.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - Movies: Similar](https://developer.themoviedb.org/reference/movie-similar)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie for get similar movies for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar movies for the matching movie as a pageable list.
    ///
    public func similar(toMovie movieID: Movie.ID, page: Int? = nil) async throws -> MoviePageableList {
        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: MoviesEndpoint.similar(movieID: movieID, page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    ///
    /// Returns a list of currently playing movies.
    ///
    /// [TMDb API - Movie Lists: Now Playing](https://developer.themoviedb.org/reference/movie-now-playing-list)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Now playing movies as a pageable list.
    ///
    public func nowPlaying(page: Int? = nil) async throws -> MoviePageableList {
        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: MoviesEndpoint.nowPlaying(page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    ///
    /// Returns a list of current popular movies.
    ///
    /// [TMDb API - Movie List: Popular](https://developer.themoviedb.org/reference/movie-popular-list)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular movies as a pageable list.
    ///
    public func popular(page: Int? = nil) async throws -> MoviePageableList {
        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: MoviesEndpoint.popular(page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    ///
    /// Returns a list of top rated movies.
    ///
    /// [TMDb API - Movie List: Top Rated](https://developer.themoviedb.org/reference/movie-top-rated-list)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated movies as a pageable list.
    ///
    public func topRated(page: Int? = nil) async throws -> MoviePageableList {
        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: MoviesEndpoint.topRated(page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    ///
    /// Returns a list of upcoming movies.
    ///
    /// [TMDb API - Movie List: Upcoming](https://developer.themoviedb.org/reference/movie-upcoming-list)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Upcoming movies as a pageable list.
    ///
    public func upcoming(page: Int? = nil) async throws -> MoviePageableList {
        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: MoviesEndpoint.upcoming(page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    ///
    /// Returns watch providers for a movie
    ///
    /// [TMDb API - Movie: Watch providers](https://developer.themoviedb.org/reference/movie-watch-providers)
    ///
    /// - Parameters:
    ///    - id: The identifier of the movie.
    ///
    /// - Throws: TMDb data error ``TMDbError``.
    ///
    /// - Returns: Watch providers for movie in current region.
    ///
    public func watchProviders(forMovie id: Movie.ID) async throws -> ShowWatchProvider? {
        guard let regionCode = localeProvider.regionCode else {
            return nil
        }
        let result: ShowWatchProviderResult
        do {
            result = try await apiClient.get(endpoint: MoviesEndpoint.watch(movieID: id))
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results[regionCode]
    }

    ///
    /// Returns a collection of media databases and social links for a movie.
    ///
    /// [TMDb API - Movie: External IDs](https://developer.themoviedb.org/reference/movie-external-ids)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///
    /// - Returns: A collection of external links for the specificed movie.
    ///
    public func externalLinks(forMovie movieID: Movie.ID) async throws -> MovieExternalLinksCollection {
        let linksCollection: MovieExternalLinksCollection
        do {
            linksCollection = try await apiClient.get(endpoint: MoviesEndpoint.externalIDs(movieID: movieID))
        } catch let error {
            throw TMDbError(error: error)
        }

        return linksCollection
    }

}
