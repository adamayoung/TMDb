//
//  AlternativeTitleCollection.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a collection of alternative titles.
///
public struct AlternativeTitleCollection: Codable, Equatable, Hashable, Sendable {

    ///
    /// Media identifier.
    ///
    public let id: Int

    ///
    /// Alternative titles.
    ///
    public let titles: [AlternativeTitle]

    ///
    /// Creates an alternative title collection object.
    ///
    /// - Parameters:
    ///   - id: Media identifier.
    ///   - titles: Alternative titles.
    ///
    public init(id: Int, titles: [AlternativeTitle]) {
        self.id = id
        self.titles = titles
    }

}

extension AlternativeTitleCollection {

    private enum CodingKeys: String, CodingKey {
        case id
        case titles = "results"
    }

}
