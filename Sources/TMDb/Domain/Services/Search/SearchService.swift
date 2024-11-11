//
//  SearchService.swift
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
/// Provides an interface for searching content from TMDb..
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol SearchService: Sendable {

    ///
    /// Returns search results for movies, TV series and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developer.themoviedb.org/reference/search-multi)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies, TV series and people matching the query.
    ///
    func searchAll(
        query: String,
        filter: AllMediaSearchFilter?,
        page: Int?,
        language: String?
    ) async throws -> MediaPageableList

    ///
    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developer.themoviedb.org/reference/search-movie)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies matching the query.
    ///
    func searchMovies(
        query: String,
        filter: MovieSearchFilter?,
        page: Int?,
        language: String?
    ) async throws -> MoviePageableList

    ///
    /// Returns search results for TV series.
    ///
    /// [TMDb API - Search: TV](https://developer.themoviedb.org/reference/search-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series matching the query.
    ///
    func searchTVSeries(
        query: String,
        filter: TVSeriesSearchFilter?,
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList

    ///
    /// Returns search results for people.
    ///
    /// [TMDb API - Search: Person](https://developer.themoviedb.org/reference/search-person)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: People matching the query.
    ///
    func searchPeople(
        query: String,
        filter: PersonSearchFilter?,
        page: Int?,
        language: String?
    ) async throws -> PersonPageableList

}

extension SearchService {

    public func searchAll(
        query: String,
        filter: AllMediaSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MediaPageableList {
        try await searchAll(query: query, filter: filter, page: page, language: language)
    }

    public func searchMovies(
        query: String,
        filter: MovieSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        try await searchMovies(query: query, filter: filter, page: page, language: language)
    }

    public func searchTVSeries(
        query: String,
        filter: TVSeriesSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await searchTVSeries(query: query, filter: filter, page: page, language: language)
    }

    public func searchPeople(
        query: String,
        filter: PersonSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> PersonPageableList {
        try await searchPeople(query: query, filter: filter, page: page, language: language)
    }

}
