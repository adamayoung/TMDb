//
//  ReviewService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for obtaining review data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol ReviewService: Sendable {

    ///
    /// Returns a review's details.
    ///
    /// [TMDb API - Reviews: Details](https://developer.themoviedb.org/reference/review-details)
    ///
    /// - Parameter id: The identifier of the review.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching review.
    ///
    func details(forReview id: Review.ID) async throws -> Review

}
