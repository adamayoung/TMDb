//
//  V4AccessToken.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TMDb v4 user access token.
///
/// An access token authorises requests on behalf of a TMDb user. It is
/// obtained by exchanging a user-approved ``V4RequestToken`` via
/// ``V4AuthenticationService/createAccessToken(withRequestToken:)``.
///
/// Access tokens are long lived — they remain valid until they are revoked,
/// either with ``V4AuthenticationService/deleteAccessToken(_:)`` or from the
/// user's TMDb account settings. Treat one as a credential: store it in the
/// keychain rather than in user defaults or source control.
///
public struct V4AccessToken: Codable, Equatable, Hashable, Sendable {

    ///
    /// Was access token creation successful.
    ///
    public let success: Bool

    ///
    /// An access token authorising requests on behalf of the user.
    ///
    public let accessToken: String

    ///
    /// The identifier of the TMDb account that approved the token.
    ///
    /// This is the v4 account object identifier — an opaque string, distinct
    /// from the integer account identifier used by the v3 API.
    ///
    public let accountID: String

    ///
    /// Creates a TMDb v4 user access token object.
    ///
    /// - Parameters:
    ///   - success: Was access token creation successful.
    ///   - accessToken: An access token authorising requests on behalf of the user.
    ///   - accountID: The identifier of the TMDb account that approved the token.
    ///
    public init(success: Bool, accessToken: String, accountID: String) {
        self.success = success
        self.accessToken = accessToken
        self.accountID = accountID
    }

}

extension V4AccessToken {

    /// The decoder applies `.convertFromSnakeCase`, so `account_id` arrives as
    /// `accountId` — the key must be spelled in that post-conversion form, not
    /// as the raw wire name.
    private enum CodingKeys: String, CodingKey {
        case success
        case accessToken
        case accountID = "accountId"
    }

}
