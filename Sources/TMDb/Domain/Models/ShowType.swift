//
//  ShowType.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a show type.
///
public enum ShowType: String, Codable, Sendable {

    ///
    /// Movie.
    ///
    case movie

    ///
    /// TV series.
    ///
    case tvSeries = "tv"

}
