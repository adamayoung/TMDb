//
//  TMDbMovieService.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbMovieService: MovieService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func details(forMovie id: Movie.ID, language: String? = nil) async throws -> Movie {
        let request = MovieRequest(id: id, language: language)

        let movie: Movie
        do {
            movie = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movie
    }

    func credits(forMovie movieID: Movie.ID, language: String? = nil) async throws -> ShowCredits {
        let request = MovieCreditsRequest(id: movieID, language: language)

        let credits: ShowCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    func reviews(
        forMovie movieID: Movie.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> ReviewPageableList {
        let request = MovieReviewsRequest(id: movieID, page: page, language: language)

        let reviewList: ReviewPageableList
        do {
            reviewList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return reviewList
    }

    func images(forMovie movieID: Movie.ID, filter: MovieImageFilter? = nil) async throws
        -> ImageCollection
    {
        let request = MovieImagesRequest(id: movieID, languages: filter?.languages)

        let imageCollection: ImageCollection
        do {
            imageCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    func videos(forMovie movieID: Movie.ID, filter: MovieVideoFilter? = nil) async throws
        -> VideoCollection
    {
        let request = MovieVideosRequest(id: movieID, languages: filter?.languages)

        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return videoCollection
    }

    func recommendations(
        forMovie movieID: Movie.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        let request = MovieRecommendationsRequest(id: movieID, page: page, language: language)

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func similar(
        toMovie movieID: Movie.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        let request = SimilarMoviesRequest(id: movieID, page: page, language: language)

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func nowPlaying(
        page: Int? = nil,
        country: String? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        let request = MoviesNowPlayingRequest(page: page, country: country, language: language)

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func popular(
        page: Int? = nil,
        country: String? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        let request = PopularMoviesRequest(page: page, country: country, language: language)

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func topRated(
        page: Int? = nil,
        country: String? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        let request = TopRatedMoviesRequest(page: page, country: country, language: language)

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func upcoming(
        page: Int? = nil,
        country: String? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        let request = UpcomingMoviesRequest(page: page, country: country, language: language)

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func watchProviders(forMovie movieID: Movie.ID, country: String = "US") async throws
        -> ShowWatchProvider?
    {
        let request = MovieWatchProvidersRequest(id: movieID)

        let result: ShowWatchProviderResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results[country]
    }

    func externalLinks(forMovie movieID: Movie.ID) async throws -> MovieExternalLinksCollection {
        let request = MovieExternalLinksRequest(id: movieID)

        let linksCollection: MovieExternalLinksCollection
        do {
            linksCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return linksCollection
    }

    func releaseDates(forMovie movieID: Movie.ID) async throws -> [MovieReleaseDatesByCountry] {
        let request = MovieReleaseDatesRequest(id: movieID)

        let result: MovieReleaseDatesResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
    }

}
