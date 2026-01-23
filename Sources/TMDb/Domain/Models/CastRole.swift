//
//  CastRole.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an aggregate cast member's role.
///
public struct CastRole: Codable, Equatable, Hashable, Sendable {

    ///
    /// Credit identifier.
    ///
    public let creditID: String

    ///
    /// Cast member's character.
    ///
    public let character: String

    ///
    /// Number of episodes this cast member appeared in in this role.
    ///
    public let episodeCount: Int

    ///
    /// Creates an aggregate cast member's role object.
    ///
    /// - Parameters:
    ///   - creditID: Credit identifier.
    ///   - character: Cast member's character.
    ///   - episodeCount: Number of episodes this cast member appeared in in
    ///   this role.
    ///
    public init(
        creditID: String,
        character: String,
        episodeCount: Int
    ) {
        self.creditID = creditID
        self.character = character
        self.episodeCount = episodeCount
    }

}

extension CastRole {

    private enum CodingKeys: String, CodingKey {
        case creditID = "creditId"
        case character
        case episodeCount
    }

}
