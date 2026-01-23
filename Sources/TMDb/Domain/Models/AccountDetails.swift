//
//  AccountDetails.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TMDb user's account details.
///
public struct AccountDetails: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// User identifier.
    ///
    public let id: Int

    ///
    /// Username.
    ///
    public let username: String

    ///
    /// User's name.
    ///
    public let name: String

    ///
    /// User's avatars.
    ///
    public let avatar: AccountAvatar

    ///
    /// User's language.
    ///
    public let languageCode: String

    ///
    /// User's country.
    ///
    public let countryCode: String

    ///
    /// Whether or not the user wants to include adult content in results.
    ///
    public let includeAdult: Bool

    ///
    /// Creates an account details object.
    ///
    /// - Parameters:
    ///   - id: User identifier.
    ///   - username: Username.
    ///   - name: User's name.
    ///   - avatar: User's avatars.
    ///   - languageCode: User's language.
    ///   - countryCode: User's country.
    ///   - includeAdult: Whether or not the user wants to include adult content in results.
    ///
    public init(
        id: Int,
        username: String,
        name: String,
        avatar: AccountAvatar,
        languageCode: String,
        countryCode: String,
        includeAdult: Bool
    ) {
        self.id = id
        self.username = username
        self.name = name
        self.avatar = avatar
        self.languageCode = languageCode
        self.countryCode = countryCode
        self.includeAdult = includeAdult
    }

}

extension AccountDetails {

    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case avatar
        case languageCode = "iso6391"
        case countryCode = "iso31661"
        case includeAdult
    }

}
