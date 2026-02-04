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

public extension AlternativeTitleCollection {

    private enum CodingKeys: String, CodingKey {
        case id
        case titles
        case results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)

        // Movies API uses "titles", TV Series API uses "results"
        if let titles = try container.decodeIfPresent([AlternativeTitle].self, forKey: .titles) {
            self.titles = titles
        } else if let results = try container.decodeIfPresent([AlternativeTitle].self, forKey: .results) {
            self.titles = results
        } else {
            self.titles = []
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(titles, forKey: .titles)
    }

}
