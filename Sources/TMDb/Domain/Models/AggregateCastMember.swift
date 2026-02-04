//
//  AggregateCastMember.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an aggregate cast member.
///
public struct AggregateCastMember: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Person identifier.
    ///
    public let id: Int

    ///
    /// Cast member's name.
    ///
    public let name: String

    ///
    /// Cast member's original name.
    ///
    public let originalName: String

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
    /// Cast member's roles.
    ///
    public let roles: [CastRole]

    ///
    /// Department this person is known for.
    ///
    public let knownForDepartment: String?

    ///
    /// Is the cast member only suitable for adults.
    ///
    public let isAdultOnly: Bool?

    ///
    /// Total episodes this cast member appears in.
    ///
    public let totalEpisodeCount: Int

    ///
    /// Cast member's popularity.
    ///
    public let popularity: Double?

    ///
    /// Creates an aggregate cast member object.
    ///
    /// - Parameters:
    ///   - id: Person identifier.
    ///   - name: Cast member's name.
    ///   - originalName: Cast member's original name.
    ///   - gender: Cast member's gender.
    ///   - profilePath: Cast member's profile image.
    ///   - roles: Cast member's roles.
    ///   - knownForDepartment: Department this person is known for.
    ///   - isAdultOnly: Is the cast member only suitable for adults.
    ///   - totalEpisodeCount: Total episodes this cast member appears in.
    ///   - popularity: Cast member's popularity.
    ///
    public init(
        id: Int,
        name: String,
        originalName: String,
        gender: Gender,
        profilePath: URL?,
        roles: [CastRole],
        knownForDepartment: String?,
        isAdultOnly: Bool?,
        totalEpisodeCount: Int,
        popularity: Double?
    ) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.gender = gender
        self.profilePath = profilePath
        self.roles = roles
        self.knownForDepartment = knownForDepartment
        self.isAdultOnly = isAdultOnly
        self.totalEpisodeCount = totalEpisodeCount
        self.popularity = popularity
    }

}

extension AggregateCastMember {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName
        case gender
        case profilePath
        case roles
        case knownForDepartment
        case isAdultOnly = "adult"
        case totalEpisodeCount
        case popularity
    }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested
    /// type.
    /// - Throws: `DecodingError.keyNotFound` if self does not have an entry for the given key.
    /// - Throws: `DecodingError.valueNotFound` if self has a null entry for the given key.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.originalName = try container.decode(String.self, forKey: .originalName)
        self.gender = (try? container.decodeIfPresent(Gender.self, forKey: .gender)) ?? .unknown
        self.profilePath = try container.decodeIfPresent(URL.self, forKey: .profilePath)
        self.roles = try container.decode([CastRole].self, forKey: .roles)
        self.knownForDepartment = try container.decodeIfPresent(
            String.self, forKey: .knownForDepartment
        )
        self.isAdultOnly = try container.decodeIfPresent(Bool.self, forKey: .isAdultOnly)
        self.totalEpisodeCount = try container.decode(Int.self, forKey: .totalEpisodeCount)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
    }

}

/// Backwards compatibility alias.
@available(*, deprecated, renamed: "AggregateCastMember")
public typealias AggregrateCastMember = AggregateCastMember
