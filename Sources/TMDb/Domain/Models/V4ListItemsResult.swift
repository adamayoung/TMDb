//
//  V4ListItemsResult.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing the outcome of adding, updating or removing items in a
/// v4 list.
///
/// - Important: ``success`` describes the *request*, not every item. TMDb
///   answers `success: true` for a request in which individual items failed —
///   removing an item that is not in the list is the easy case to reproduce —
///   so check ``results`` rather than ``success`` alone. ``failures`` is there
///   for exactly that.
///
public struct V4ListItemsResult: Codable, Equatable, Hashable, Sendable {

    ///
    /// Whether TMDb accepted the request.
    ///
    public let success: Bool

    ///
    /// The per-item outcomes, in the order TMDb returned them.
    ///
    public let results: [V4ListItemResult]

    ///
    /// The items that failed, if any.
    ///
    public var failures: [V4ListItemResult] {
        results.filter { !$0.success }
    }

    ///
    /// Whether every individual item succeeded.
    ///
    public var allItemsSucceeded: Bool {
        success && failures.isEmpty
    }

    ///
    /// Creates a v4 list items result.
    ///
    /// - Parameters:
    ///    - success: Whether TMDb accepted the request.
    ///    - results: The per-item outcomes.
    ///
    public init(success: Bool, results: [V4ListItemResult] = []) {
        self.success = success
        self.results = results
    }

}

public extension V4ListItemsResult {

    ///
    /// Creates a v4 list items result by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: An error if reading from the decoder fails, or if the data is
    ///   corrupted or otherwise invalid.
    ///
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.results = try container.decodeIfPresent(
            [V4ListItemResult].self, forKey: .results
        ) ?? []
    }

}

///
/// A model representing the outcome for one item in a v4 list write.
///
public struct V4ListItemResult: Codable, Equatable, Hashable, Sendable {

    ///
    /// Whether the item is a movie or a TV series.
    ///
    public let mediaType: ShowType

    ///
    /// The identifier of the movie or TV series.
    ///
    public let mediaID: Int

    ///
    /// Whether this item succeeded.
    ///
    public let success: Bool

    ///
    /// Creates a v4 list item result.
    ///
    /// - Parameters:
    ///    - mediaType: Whether the item is a movie or a TV series.
    ///    - mediaID: The identifier of the movie or TV series.
    ///    - success: Whether this item succeeded.
    ///
    public init(mediaType: ShowType, mediaID: Int, success: Bool) {
        self.mediaType = mediaType
        self.mediaID = mediaID
        self.success = success
    }

}

extension V4ListItemResult {

    private enum CodingKeys: String, CodingKey {
        case mediaType
        case mediaID = "mediaId"
        case success
    }

}
