//
//  ShowWatchProvider.swift
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
/// A model representing a show's watch provider.
///
public struct ShowWatchProvider: Equatable, Codable {

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
