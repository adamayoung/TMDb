//
//  TMDbGenreService.swift
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
/// Provides an interface for obtaining movie and TV series genres from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbGenreService: GenreService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func movieGenres(language: String? = nil) async throws -> [Genre] {
        let request = MovieGenresRequest(language: language)

        let genreList: GenreList
        do {
            genreList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return genreList.genres
    }

    func tvSeriesGenres(language: String? = nil) async throws -> [Genre] {
        let request = TVSeriesGenresRequest(language: language)

        let genreList: GenreList
        do {
            genreList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return genreList.genres
    }

}
