//
//  CompanyService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for obtaining company data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol CompanyService: Sendable {

    ///
    /// Returns a company's details
    ///
    /// [TMDb API - Companies: Details](https://developer.themoviedb.org/reference/company-details)
    ///
    /// - Parameter id: The identifier of the company.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching company.
    ///
    func details(forCompany id: Company.ID) async throws -> Company

}
