//
//  KeywordService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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

public extension KeywordService {

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
    func movies(forKeyword keywordID: Keyword.ID) async throws -> MoviePageableList {
        try await movies(forKeyword: keywordID, page: nil, language: nil)
    }

}
