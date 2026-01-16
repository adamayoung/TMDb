//
//  ShowWatchProvidersByCountry.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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
/// A model representing watch provider information for a specific country.
///
public struct ShowWatchProvidersByCountry: Codable, Equatable, Hashable, Sendable {

    ///
    /// ISO 3166-1 country code.
    ///
    public let countryCode: String

    ///
    /// Watch provider information for this country.
    ///
    public let watchProviders: ShowWatchProvider

    ///
    /// Creates a show watch providers by country object.
    ///
    /// - Parameters:
    ///   - countryCode: ISO 3166-1 country code.
    ///   - watchProviders: Watch provider information for this country.
    ///
    public init(countryCode: String, watchProviders: ShowWatchProvider) {
        self.countryCode = countryCode
        self.watchProviders = watchProviders
    }

}
