//
//  ReviewAuthorDetails.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing the author details of a review.
///
public struct ReviewAuthorDetails: Codable, Equatable, Hashable, Sendable {

    ///
    /// Author's display name.
    ///
    public let name: String

    ///
    /// Author's username.
    ///
    public let username: String

    ///
    /// Author's avatar image path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let avatarPath: URL?

    ///
    /// Author's rating.
    ///
    public let rating: Double?

    ///
    /// Creates a review author details object.
    ///
    /// - Parameters:
    ///   - name: Author's display name.
    ///   - username: Author's username.
    ///   - avatarPath: Author's avatar image path.
    ///   - rating: Author's rating.
    ///
    public init(
        name: String,
        username: String,
        avatarPath: URL? = nil,
        rating: Double? = nil
    ) {
        self.name = name
        self.username = username
        self.avatarPath = avatarPath
        self.rating = rating
    }

}
