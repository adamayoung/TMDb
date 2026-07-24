//
//  RuntimeMinutes.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Bridges TMDb's integer-minute runtimes to and from `Duration`.
///
/// TMDb represents runtimes as a whole number of minutes on the wire, while the
/// package exposes them as `Duration`. These helpers convert between the two
/// representations at that boundary.
///
enum RuntimeMinutes {

    ///
    /// Converts a whole number of minutes into a `Duration`.
    ///
    /// - Parameter minutes: A number of whole minutes.
    ///
    /// - Returns: The equivalent `Duration`.
    ///
    static func duration(fromMinutes minutes: Int) -> Duration {
        .seconds(minutes * 60)
    }

    ///
    /// Converts a `Duration` into a whole number of minutes.
    ///
    /// Any sub-minute remainder is truncated towards zero.
    ///
    /// - Parameter duration: A duration.
    ///
    /// - Returns: The number of whole minutes in `duration`.
    ///
    static func minutes(from duration: Duration) -> Int {
        Int(duration.components.seconds / 60)
    }

}
