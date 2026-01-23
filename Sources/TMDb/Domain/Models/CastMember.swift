//
//  CastMember.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a cast member.
///
public struct CastMember: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Cast member's identifier.
    ///
    public let id: Int

    ///
    /// Cast member's identifier for the particular movie or TV series.
    ///
    public let castID: Int?

    ///
    /// Credit identifier for that particular movie or TV series.
    ///
    public let creditID: String

    ///
    /// Cast member's real name.
    ///
    public let name: String

    ///
    /// Cast member's character name.
    ///
    public let character: String

    ///
    /// Cast member's gender.
    ///
    public let gender: Gender

    ///
    /// Cast member's profile image.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let profilePath: URL?

    ///
    /// Order number in the cast list.
    ///
    public let order: Int

    ///
    /// Creates a cast member object.
    ///
    /// - Parameters:
    ///    - id: Cast member's identifier.
    ///    - castID: Cast member's identifier for the particular movie or TV series.
    ///    - creditID: Credit identifier for that particular movie or TV series.
    ///    - name: Cast member's name.
    ///    - character: Cast member's character name.
    ///    - gender: Cast member's gender.
    ///    - profilePath: Cast member's profile image.
    ///    - order: Order number in the cast list.
    ///
    public init(
        id: Int,
        castID: Int? = nil,
        creditID: String,
        name: String,
        character: String,
        gender: Gender = .unknown,
        profilePath: URL? = nil,
        order: Int
    ) {
        self.id = id
        self.castID = castID
        self.creditID = creditID
        self.name = name
        self.character = character
        self.gender = gender
        self.profilePath = profilePath
        self.order = order
    }

}

extension CastMember {

    private enum CodingKeys: String, CodingKey {
        case id
        case castID = "castId"
        case creditID = "creditId"
        case name
        case character
        case gender
        case profilePath
        case order
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.castID = try container.decodeIfPresent(Int.self, forKey: .castID)
        self.creditID = try container.decode(String.self, forKey: .creditID)
        self.name = try container.decode(String.self, forKey: .name)
        self.character = try container.decode(String.self, forKey: .character)
        self.gender = (try? container.decodeIfPresent(Gender.self, forKey: .gender)) ?? .unknown
        self.profilePath = try container.decodeIfPresent(URL.self, forKey: .profilePath)
        self.order = try container.decode(Int.self, forKey: .order)
    }

}
