//
//  AccountAvatar.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TMDb user's avatar.
///
public struct AccountAvatar: Codable, Equatable, Hashable, Sendable {

    ///
    /// Gravatar avatar.
    ///
    public let gravatar: AccountAvatar.Gravatar

    ///
    /// TMDb avatar.
    ///
    public let tmdb: AccountAvatar.TMDb

    ///
    /// Creates an account avatar object.
    ///
    /// - Parameters:
    ///   - gravatar: Gravatar avatar.
    ///   - tmdb: TMDb avatar.
    ///
    public init(
        gravatar: AccountAvatar.Gravatar,
        tmdb: AccountAvatar.TMDb
    ) {
        self.gravatar = gravatar
        self.tmdb = tmdb
    }

}

public extension AccountAvatar {

    ///
    /// A model representing a TMDb user's Gravatar avatar.
    ///
    struct Gravatar: Codable, Equatable, Hashable, Sendable {

        ///
        /// Gravatar hash.
        ///
        public let hash: String?

        /// Creates a Gravatar avatar object.
        ///
        /// - Parameter hash: Gravatar hash.
        ///
        public init(hash: String? = nil) {
            self.hash = hash
        }

    }

}

public extension AccountAvatar {

    ///
    /// A model representing a TMDb user's TMDb avatar.
    ///
    struct TMDb: Codable, Equatable, Hashable, Sendable {

        ///
        /// Path of the avatar image.
        ///
        public let avatarPath: String?

        ///
        /// Creates a TMDb avatar object.
        ///
        /// - Parameter avatarPath: Path of the avatar image.
        ///
        public init(avatarPath: String? = nil) {
            self.avatarPath = avatarPath
        }
    }

}
