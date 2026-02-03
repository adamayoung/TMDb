//
//  AccountStates.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing the account state for a media item.
///
/// Provides information about whether the media has been rated, added to a watchlist, or marked as favorite
/// by the authenticated user.
///
public struct AccountStates: Codable, Equatable, Hashable, Sendable {

    ///
    /// The media item identifier.
    ///
    public let id: Int

    ///
    /// Indicates if the media is marked as a favorite.
    ///
    public let favorite: Bool

    ///
    /// The user's rating for the media.
    ///
    /// `nil` if the media has not been rated.
    ///
    public let rated: RatedValue?

    ///
    /// Indicates if the media is on the user's watchlist.
    ///
    public let watchlist: Bool

    ///
    /// Creates an account states object.
    ///
    /// - Parameters:
    ///    - id: The media item identifier.
    ///    - favorite: Indicates if the media is marked as a favorite.
    ///    - rated: The user's rating for the media.
    ///    - watchlist: Indicates if the media is on the user's watchlist.
    ///
    public init(id: Int, favorite: Bool, rated: RatedValue?, watchlist: Bool) {
        self.id = id
        self.favorite = favorite
        self.rated = rated
        self.watchlist = watchlist
    }

}

extension AccountStates {

    ///
    /// A model representing a rating value.
    ///
    public struct RatedValue: Codable, Equatable, Hashable, Sendable {

        ///
        /// The rating value.
        ///
        /// Valid range: 0.5 to 10.0 in increments of 0.5.
        ///
        public let value: Double

        ///
        /// Creates a rated value object.
        ///
        /// - Parameter value: The rating value.
        ///
        public init(value: Double) {
            self.value = value
        }

    }

}
