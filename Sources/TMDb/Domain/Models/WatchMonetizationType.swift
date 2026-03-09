//
//  WatchMonetizationType.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A watch monetization type for filtering discover results.
///
public enum WatchMonetizationType: String, Codable, Equatable, Hashable,
Sendable {

    ///
    /// Flat rate (subscription) monetization.
    ///
    case flatrate

    ///
    /// Free monetization.
    ///
    case free

    ///
    /// Ad-supported monetization.
    ///
    case ads

    ///
    /// Rental monetization.
    ///
    case rent

    ///
    /// Purchase monetization.
    ///
    case buy

}
