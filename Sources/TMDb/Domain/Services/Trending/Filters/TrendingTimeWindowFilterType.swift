//
//  TrendingTimeWindowFilterType.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Sort specifier when fetching TV series.
///
public enum TrendingTimeWindowFilterType: String, Sendable {

    ///
    /// Day time window filter.
    ///
    case day

    ///
    /// Week time window filter.
    ///
    case week

}
