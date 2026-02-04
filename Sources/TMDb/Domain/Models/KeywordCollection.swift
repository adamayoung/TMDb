//
//  KeywordCollection.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a collection of keywords.
///
public struct KeywordCollection: Codable, Equatable, Hashable, Sendable {

    ///
    /// Media identifier.
    ///
    public let id: Int

    ///
    /// Keywords.
    ///
    public let keywords: [Keyword]

    ///
    /// Creates a keyword collection object.
    ///
    /// - Parameters:
    ///   - id: Media identifier.
    ///   - keywords: Keywords.
    ///
    public init(id: Int, keywords: [Keyword]) {
        self.id = id
        self.keywords = keywords
    }

}

extension KeywordCollection {

    private enum CodingKeys: String, CodingKey {
        case id
        case keywords = "results"
    }

}
