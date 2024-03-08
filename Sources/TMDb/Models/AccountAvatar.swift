//
//  AccountAvatar.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// A model representing a TMDb user's avatar.
///
public struct AccountAvatar: Codable, Equatable, Hashable {

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
    struct Gravatar: Codable, Equatable, Hashable {

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
    struct TMDb: Codable, Equatable, Hashable {

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
