//
//  KeywordService.swift
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

///
/// Provides an interface for obtaining keyword data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol KeywordService: Sendable {

    ///
    /// Returns a keyword's details.
    ///
    /// [TMDb API - Keywords: Details](https://developer.themoviedb.org/reference/keyword-details)
    ///
    /// - Parameter id: The identifier of the keyword.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching keyword.
    ///
    func details(forKeyword id: Keyword.ID) async throws -> Keyword

    ///
    /// Returns a list of movies for a keyword.
    ///
    /// [TMDb API - Keywords: Movies](https://developer.themoviedb.org/reference/keyword-movies)
    ///
    /// - Parameters:
    ///   - keywordID: The identifier of the keyword.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable list of movies.
    ///
    func movies(forKeyword keywordID: Keyword.ID, page: Int?, language: String?) async throws
        -> MoviePageableList

}

extension KeywordService {

    ///
    /// Returns a list of movies for a keyword.
    ///
    /// [TMDb API - Keywords: Movies](https://developer.themoviedb.org/reference/keyword-movies)
    ///
    /// - Parameter keywordID: The identifier of the keyword.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable list of movies.
    ///
    public func movies(forKeyword keywordID: Keyword.ID) async throws -> MoviePageableList {
        try await movies(forKeyword: keywordID, page: nil, language: nil)
    }

}
