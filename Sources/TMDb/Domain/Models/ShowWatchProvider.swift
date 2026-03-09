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
    public let link: URL?

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
        link: URL? = nil,
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

public extension ShowWatchProvider {

    private enum CodingKeys: String, CodingKey {
        case link
        case free
        case flatRate = "flatrate"
        case buy
        case rent
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let linkString = try container.decodeIfPresent(String.self, forKey: .link)
        self.link = linkString.flatMap { URL(string: $0) }
        self.free = try container.decodeIfPresent([WatchProvider].self, forKey: .free)
        self.flatRate = try container.decodeIfPresent([WatchProvider].self, forKey: .flatRate)
        self.buy = try container.decodeIfPresent([WatchProvider].self, forKey: .buy)
        self.rent = try container.decodeIfPresent([WatchProvider].self, forKey: .rent)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(link?.absoluteString, forKey: .link)
        try container.encodeIfPresent(free, forKey: .free)
        try container.encodeIfPresent(flatRate, forKey: .flatRate)
        try container.encodeIfPresent(buy, forKey: .buy)
        try container.encodeIfPresent(rent, forKey: .rent)
    }

}
