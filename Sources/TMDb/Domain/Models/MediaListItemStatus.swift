//
//  MediaListItemStatus.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing the presence status of an item in a list.
///
public struct MediaListItemStatus: Codable, Equatable, Hashable, Sendable {

    ///
    /// List identifier.
    ///
    public let id: String

    ///
    /// Whether the item is present in the list.
    ///
    public let isPresent: Bool

    ///
    /// Creates a media list item status object.
    ///
    /// - Parameters:
    ///    - id: List identifier.
    ///    - isPresent: Whether the item is present in the list.
    ///
    public init(id: String, isPresent: Bool) {
        self.id = id
        self.isPresent = isPresent
    }

}

extension MediaListItemStatus {

    private enum CodingKeys: String, CodingKey {
        case id
        case isPresent = "itemPresent"
    }

}
