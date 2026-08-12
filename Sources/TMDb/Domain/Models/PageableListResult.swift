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
    /// How many results were skipped while decoding this page because their media
    /// type is one this library does not model.
    ///
    /// Decode telemetry, not data: it exists so tests can assert that a page is
    /// short for a known reason rather than a regression. It is zero for a page
    /// built in code.
    ///
    private let droppedItems: DroppedItemCount

    ///
    /// How many results were skipped while decoding this page.
    ///
    package var droppedItemCount: Int {
        droppedItems.value
    }

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
        self.init(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages,
            droppedItemCount: 0
        )
    }

    ///
    /// Creates a pageable list result object carrying a decode drop count.
    ///
    /// Used where a page is assembled in code from a model that decoded the
    /// elements itself, so the count survives the hand-off.
    ///
    /// - Parameters:
    ///    - page: Page number.
    ///    - results: Results for this page of a list.
    ///    - totalResults: Total results.
    ///    - totalPages: Total pages.
    ///    - droppedItemCount: How many results were skipped while decoding.
    ///
    package init(
        page: Int? = nil,
        results: [Result],
        totalResults: Int? = nil,
        totalPages: Int? = nil,
        droppedItemCount: Int
    ) {
        self.page = page ?? 1
        self.results = results
        self.totalResults = totalResults ?? 0
        self.totalPages = totalPages ?? 0
        self.droppedItems = DroppedItemCount(droppedItemCount)
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
    /// A result whose `media_type` this library does not model is skipped rather
    /// than failing the whole page, and counted internally for tests. **Every
    /// other decode failure throws** — an element dropped for any other reason is
    /// a decoder defect, and swallowing it would turn a regression into a quietly
    /// short page with no signal at all.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: An error if reading from the decoder fails, or if the data is
    ///   corrupted or otherwise invalid.
    ///
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 1
        let results = try container.decodeSkippingUnknownMediaTypes(
            Result.self,
            forKey: .results
        )
        self.results = results.elements
        self.droppedItems = DroppedItemCount(results.dropped)
        self.totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults) ?? 0
        self.totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages) ?? 0
    }

}
