//
//  Keyword.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a keyword.
///
public struct Keyword: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Keyword identifier.
    ///
    public let id: Int

    ///
    /// Keyword name.
    ///
    public let name: String

    ///
    /// Creates a keyword object.
    ///
    /// - Parameters:
    ///   - id: Keyword identifier.
    ///   - name: Keyword name.
    ///
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

}
