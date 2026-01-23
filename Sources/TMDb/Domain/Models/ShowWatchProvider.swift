//
//  ShowWatchProvider.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a show's watch provider.
///
public struct ShowWatchProvider: Codable, Equatable, Hashable, Sendable {

    ///
    /// A link to the watch provider.
    ///
    public let link: String

    ///
    /// A list of free watch providers.
    ///
    public let free: [WatchProvider]?

    ///
    /// A list of flat rate watch providers.
    ///
    public let flatRate: [WatchProvider]?

    ///
    /// A list of watch providers to buy from.
    ///
    public let buy: [WatchProvider]?

    ///
    /// A list of watch providers to rent from.
    ///
    public let rent: [WatchProvider]?

    ///
    /// Creates a show credits object.
    ///
    /// - Parameters:
    ///   - link: A link to the watch provider.
    ///   - free: A list of free watch providers.
    ///   - flatRate: A list of flat rate watch providers.
    ///   - buy: A list of watch providers to buy from.
    ///   - rent: A list of watch providers to rent from.
    ///
    public init(
        link: String,
        free: [WatchProvider]? = nil,
        flatRate: [WatchProvider]? = nil,
        buy: [WatchProvider]? = nil,
        rent: [WatchProvider]? = nil
    ) {
        self.link = link
        self.free = free
        self.flatRate = flatRate
        self.buy = buy
        self.rent = rent
    }

}

extension ShowWatchProvider {

    private enum CodingKeys: String, CodingKey {
        case link
        case free
        case flatRate = "flatrate"
        case buy
        case rent
    }

}
