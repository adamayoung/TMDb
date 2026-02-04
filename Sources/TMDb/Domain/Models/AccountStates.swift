//
//  AccountStates.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a user's account states for media.
///
public struct AccountStates: Codable, Equatable, Hashable, Sendable {

    ///
    /// Media identifier.
    ///
    public let id: Int

    ///
    /// Is the media in the user's favorites.
    ///
    public let isFavourite: Bool

    ///
    /// The user's rating for the media.
    ///
    public let rating: Double?

    ///
    /// Is the media in the user's watchlist.
    ///
    public let isInWatchlist: Bool

    ///
    /// Creates an account states object.
    ///
    /// - Parameters:
    ///   - id: Media identifier.
    ///   - isFavourite: Is the media in the user's favorites.
    ///   - rating: The user's rating for the media.
    ///   - isInWatchlist: Is the media in the user's watchlist.
    ///
    public init(id: Int, isFavourite: Bool, rating: Double? = nil, isInWatchlist: Bool) {
        self.id = id
        self.isFavourite = isFavourite
        self.rating = rating
        self.isInWatchlist = isInWatchlist
    }

}

public extension AccountStates {

    private enum CodingKeys: String, CodingKey {
        case id
        case isFavourite = "favorite"
        case rating = "rated"
        case isInWatchlist = "watchlist"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.isFavourite = try container.decode(Bool.self, forKey: .isFavourite)
        self.isInWatchlist = try container.decode(Bool.self, forKey: .isInWatchlist)

        // rating can be false (boolean) or a number (double)
        if let ratingValue = try? container.decode(Double.self, forKey: .rating) {
            self.rating = ratingValue
        } else {
            self.rating = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(isFavourite, forKey: .isFavourite)
        try container.encode(isInWatchlist, forKey: .isInWatchlist)

        if let rating {
            try container.encode(rating, forKey: .rating)
        } else {
            try container.encode(false, forKey: .rating)
        }
    }

}
