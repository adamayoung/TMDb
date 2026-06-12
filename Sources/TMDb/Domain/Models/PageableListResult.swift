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
    /// Individual result elements are decoded tolerantly: an element that fails
    /// to decode — for example a list item with a `media_type` this library
    /// does not yet model — is skipped rather than failing the whole page.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: An error if reading from the decoder fails, or if the data is
    ///   corrupted or otherwise invalid.
    ///
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 1
        let wrapped = try container.decodeIfPresent(
            [FailableDecodable<Result>].self,
            forKey: .results
        )
        self.results = (wrapped ?? []).compactMap(\.value)
        self.totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults) ?? 0
        self.totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages) ?? 0
    }

}

///
/// A decoding wrapper that tolerates a failing element.
///
/// Decoding never throws: when the wrapped value cannot be decoded, ``value``
/// is `nil` and the element is consumed so the surrounding array continues to
/// decode. This lets a list skip an unrecognised element instead of dropping
/// the whole page.
///
private struct FailableDecodable<Wrapped: Decodable>: Decodable {

    let value: Wrapped?

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try? container.decode(Wrapped.self)
    }

}
