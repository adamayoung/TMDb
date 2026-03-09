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
    /// Cast member's original name.
    ///
    public let originalName: String?

    ///
    /// Cast member's character name.
    ///
    public let character: String

    ///
    /// Department this cast member is known for.
    ///
    public let knownForDepartment: String?

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
    /// Cast member's current popularity.
    ///
    public let popularity: Double?

    ///
    /// Order number in the cast list.
    ///
    public let order: Int

    ///
    /// Is adult only content.
    ///
    public let isAdultOnly: Bool?

    ///
    /// Creates a cast member object.
    ///
    /// - Parameters:
    ///    - id: Cast member's identifier.
    ///    - castID: Cast member's identifier for the particular movie or TV series.
    ///    - creditID: Credit identifier for that particular movie or TV series.
    ///    - name: Cast member's name.
    ///    - originalName: Cast member's original name.
    ///    - character: Cast member's character name.
    ///    - knownForDepartment: Department this cast member is known for.
    ///    - gender: Cast member's gender.
    ///    - profilePath: Cast member's profile image.
    ///    - popularity: Cast member's current popularity.
    ///    - order: Order number in the cast list.
    ///    - isAdultOnly: Is adult only content.
    ///
    public init(
        id: Int,
        castID: Int? = nil,
        creditID: String,
        name: String,
        originalName: String? = nil,
        character: String,
        knownForDepartment: String? = nil,
        gender: Gender = .unknown,
        profilePath: URL? = nil,
        popularity: Double? = nil,
        order: Int,
        isAdultOnly: Bool? = nil
    ) {
        self.id = id
        self.castID = castID
        self.creditID = creditID
        self.name = name
        self.originalName = originalName
        self.character = character
        self.knownForDepartment = knownForDepartment
        self.gender = gender
        self.profilePath = profilePath
        self.popularity = popularity
        self.order = order
        self.isAdultOnly = isAdultOnly
    }

}

extension CastMember {

    private enum CodingKeys: String, CodingKey {
        case id
        case castID = "castId"
        case creditID = "creditId"
        case name
        case originalName
        case character
        case knownForDepartment
        case gender
        case profilePath
        case popularity
        case order
        case isAdultOnly = "adult"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.castID = try container.decodeIfPresent(Int.self, forKey: .castID)
        self.creditID = try container.decode(String.self, forKey: .creditID)
        self.name = try container.decode(String.self, forKey: .name)
        self.originalName = try container.decodeIfPresent(
            String.self, forKey: .originalName
        )
        self.character = try container.decode(String.self, forKey: .character)
        self.knownForDepartment = try container.decodeIfPresent(
            String.self, forKey: .knownForDepartment
        )
        self.gender = (try? container.decodeIfPresent(
            Gender.self, forKey: .gender
        )) ?? .unknown
        self.profilePath = try container.decodeIfPresent(
            URL.self, forKey: .profilePath
        )
        self.popularity = try container.decodeIfPresent(
            Double.self, forKey: .popularity
        )
        self.order = try container.decode(Int.self, forKey: .order)
        self.isAdultOnly = try container.decodeIfPresent(
            Bool.self, forKey: .isAdultOnly
        )
    }

}
