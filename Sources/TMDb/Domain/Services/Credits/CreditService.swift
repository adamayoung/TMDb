//
//  CreditService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for obtaining credit data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol CreditService: Sendable {

    ///
    /// Returns a credit's details.
    ///
    /// [TMDb API - Credits: Details](https://developer.themoviedb.org/reference/credit-details)
    ///
    /// - Parameter id: The identifier of the credit.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching credit.
    ///
    func details(forCredit id: Credit.ID) async throws -> Credit

}
