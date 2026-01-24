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
    /// Is adult?
    ///
    public let adult: Bool?

    ///
    /// Total episodes this cast member appears in.
    ///
    public let totalEpisodeCount: Int

    ///
    /// Cast member's popularity.
    ///
    public let popularity: Double?

    ///
    /// Creates an aggregate cast member's role object.
    ///
    /// - Parameters:
    ///   - id: Person identifier.
    ///   - name: Cast member's name.
    ///   - originalName: Cast member's original name.
    ///   - gender: Cast member's gender.
    ///   - profilePath: Cast member's profile image.
    ///   - roles: Cast member's roles.
    ///   - knownForDepartment: Department this person is known for.
    ///   - adult: Is adult?
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
        adult: Bool?,
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
        self.adult = adult
        self.totalEpisodeCount = totalEpisodeCount
        self.popularity = popularity
    }

}

/// Backwards compatibility alias.
@available(*, deprecated, renamed: "AggregateCastMember")
public typealias AggregrateCastMember = AggregateCastMember
