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
    public let page: Int

    ///
    /// Results for this page of a list.
    ///
    public let results: [Result]

    ///
    /// Total results.
    ///
    public let totalResults: Int

    ///
    /// Total pages.
    ///
    public let totalPages: Int

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
        self.page = page ?? 1
        self.results = results
        self.totalResults = totalResults ?? 0
        self.totalPages = totalPages ?? 0
    }

}

extension PageableListResult {

    private enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalResults
        case totalPages
    }

    ///
    /// Creates a pageable list result object by decoding from the given decoder.
    ///
    /// Missing or `null` count fields fall back to sensible defaults: `page`
    /// defaults to `1`, while `totalResults` and `totalPages` default to `0`.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: An error if reading from the decoder fails, or if the data is
    ///   corrupted or otherwise invalid.
    ///
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 1
        self.results = try container.decode([Result].self, forKey: .results)
        self.totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults) ?? 0
        self.totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages) ?? 0
    }

}
