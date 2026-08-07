//
//  V4ClearListResult.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing the result of clearing a v4 list.
///
public struct V4ClearListResult: Codable, Equatable, Hashable, Sendable {

    ///
    /// Whether the list was cleared.
    ///
    public let success: Bool

    ///
    /// The identifier of the list that was cleared.
    ///
    public let id: Int

    ///
    /// How many items were removed.
    ///
    public let itemsDeleted: Int

    ///
    /// Creates a clear-list result.
    ///
    /// - Parameters:
    ///    - success: Whether the list was cleared.
    ///    - id: The identifier of the list that was cleared.
    ///    - itemsDeleted: How many items were removed.
    ///
    public init(success: Bool, id: Int, itemsDeleted: Int) {
        self.success = success
        self.id = id
        self.itemsDeleted = itemsDeleted
    }

}
