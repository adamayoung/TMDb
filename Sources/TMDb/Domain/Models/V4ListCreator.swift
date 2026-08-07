//
//  V4ListCreator.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing the creator of a v4 list.
///
/// The v4 API sends the creator as an object, where v3 sends only a username
/// string — which is one of the reasons the v3 list models cannot be reused.
///
public struct V4ListCreator: Codable, Equatable, Hashable, Sendable {

    ///
    /// The creator's account object identifier.
    ///
    public let id: String

    ///
    /// The creator's display name.
    ///
    /// TMDb sends an empty string when the user has not set one.
    ///
    public let name: String

    ///
    /// The creator's username.
    ///
    public let username: String

    ///
    /// Path to the creator's avatar image.
    ///
    public let avatarPath: URL?

    ///
    /// The creator's Gravatar hash.
    ///
    public let gravatarHash: String?

    ///
    /// Creates a list creator object.
    ///
    /// - Parameters:
    ///    - id: The creator's account object identifier.
    ///    - name: The creator's display name.
    ///    - username: The creator's username.
    ///    - avatarPath: Path to the creator's avatar image.
    ///    - gravatarHash: The creator's Gravatar hash.
    ///
    public init(
        id: String,
        name: String,
        username: String,
        avatarPath: URL? = nil,
        gravatarHash: String? = nil
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.avatarPath = avatarPath
        self.gravatarHash = gravatarHash
    }

}
