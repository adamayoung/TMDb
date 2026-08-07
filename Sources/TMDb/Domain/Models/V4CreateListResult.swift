//
//  V4CreateListResult.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing the result of creating a v4 list.
///
public struct V4CreateListResult: Codable, Equatable, Hashable, Sendable {

    ///
    /// Whether the list was created.
    ///
    public let success: Bool

    ///
    /// The identifier of the new list.
    ///
    /// - Note: v4 returns this as `id`, where the v3 create endpoint returns
    ///   `list_id`.
    ///
    public let id: Int

    ///
    /// Creates a create-list result.
    ///
    /// - Parameters:
    ///    - success: Whether the list was created.
    ///    - id: The identifier of the new list.
    ///
    public init(success: Bool, id: Int) {
        self.success = success
        self.id = id
    }

}
