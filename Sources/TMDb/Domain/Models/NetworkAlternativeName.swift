//
//  NetworkAlternativeName.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an alternative name for a TV network.
///
public struct NetworkAlternativeName: Codable, Equatable, Hashable, Sendable {

    ///
    /// The alternative name.
    ///
    public let name: String

    ///
    /// The type of alternative name.
    ///
    public let type: String

    ///
    /// Creates an alternative name for a TV network.
    ///
    /// - Parameters:
    ///    - name: The alternative name.
    ///    - type: The type of alternative name.
    ///
    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }

}
