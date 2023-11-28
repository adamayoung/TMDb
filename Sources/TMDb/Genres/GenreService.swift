//
//  GenreService.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
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
/// Provides an interface for obtaining movie and TV series genres from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class GenreService {

    private let apiClient: APIClient

    ///
    /// Creates a genre service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns the list of official genres for movies.
    ///
    /// [TMDb API - Genres: Movie List](https://developer.themoviedb.org/reference/genre-movie-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of genres.
    ///
    public func movieGenres() async throws -> [Genre] {
        let genreList: GenreList
        do {
            genreList = try await apiClient.get(endpoint: GenresEndpoint.movie)
        } catch let error {
            throw TMDbError(error: error)
        }

        return genreList.genres
    }

    ///
    /// Returns the list of official genres for TV series.
    ///
    /// [TMDb API - Genres: TV List](https://developer.themoviedb.org/reference/genre-tv-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of genres.
    ///
    public func tvSeriesGenres() async throws -> [Genre] {
        let genreList: GenreList
        do {
            genreList = try await apiClient.get(endpoint: GenresEndpoint.tvSeries)
        } catch let error {
            throw TMDbError(error: error)
        }

        return genreList.genres
    }

}
