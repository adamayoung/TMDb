//
//  PageableListResult.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a pageable list of items.
///
public struct PageableListResult<Result: Codable & Identifiable & Equatable & Hashable & Sendable>:
Codable, Equatable, Hashable, Sendable {

    ///
    /// Page number.
    ///
    public let page: Int?

    ///
    /// Results for this page of a list.
    ///
    public let results: [Result]

    ///
    /// Total results.
    ///
    public let totalResults: Int?

    ///
    /// Total pages.
    ///
    public let totalPages: Int?

    ///
    /// Creates a pageable list result object.
    ///
    /// - Parameters:
    ///    - page: Page number.
    ///    - results: Results for this page of a list.
    ///    - totalResults: Total results.
    ///    - totalPages: Total pages.
    ///
    public init(
        page: Int? = nil,
        results: [Result],
        totalResults: Int? = nil,
        totalPages: Int? = nil
    ) {
        self.page = page
        self.results = results
        self.totalResults = totalResults
        self.totalPages = totalPages
    }

}
