//
//  Timezone.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a timezone.
///
public struct Timezone: Codable, Equatable, Hashable, Sendable {

    ///
    /// ISO 3166-1 country code.
    ///
    public let iso31661: String

    ///
    /// Timezone zone names.
    ///
    public let zones: [String]

    ///
    /// Creates a timezone object.
    ///
    /// - Parameters:
    ///   - iso31661: ISO 3166-1 country code.
    ///   - zones: Timezone zone names.
    ///
    public init(iso31661: String, zones: [String]) {
        self.iso31661 = iso31661
        self.zones = zones
    }

}
