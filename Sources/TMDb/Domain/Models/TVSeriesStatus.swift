//
//  TVSeriesStatus.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A TV series status used for discover filtering.
///
public enum TVSeriesStatus: Int, Codable, Equatable, Hashable,
Sendable {

    /// Returning series.
    case returning = 0

    /// Planned series.
    case planned = 1

    /// In production.
    case inProduction = 2

    /// Ended series.
    case ended = 3

    /// Cancelled series.
    case cancelled = 4

    /// Pilot.
    case pilot = 5

}
