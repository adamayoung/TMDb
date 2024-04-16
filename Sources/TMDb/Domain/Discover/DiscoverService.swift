//
//  DiscoverService.swift
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
/// Provides an interface for discovering movies and TV series from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class DiscoverService {

    private let repository: any DiscoverRepository

    ///
    /// Creates a discover service object.
    ///
    /// - Parameter session: A TMDb configuration object.
    ///
    public convenience init(configuration: TMDbConfiguration) {
        self.init(
            repository: TMDbFactory.discoverRepository(configuration: configuration)
        )
    }

    init(repository: some DiscoverRepository) {
        self.repository = repository
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - people: A list of Person identifiers which to return only movies they have appeared in.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    public func movies(
        sortedBy: MovieSort? = nil,
        withPeople people: [Person.ID]? = nil,
        page: Int? = nil
    ) async throws -> MoviePageableList {
        try await repository.movies(sortedBy: sortedBy, withPeople: people, page: page)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    public func tvSeries(sortedBy: TVSeriesSort? = nil, page: Int? = nil) async throws -> TVSeriesPageableList {
        try await repository.tvSeries(sortedBy: sortedBy, page: page)
    }

}
