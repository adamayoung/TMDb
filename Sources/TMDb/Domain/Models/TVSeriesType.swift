//
//  TVSeriesType.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A TV series type used for discover filtering.
///
public enum TVSeriesType: Int, Codable, Equatable, Hashable,
Sendable {

    /// Documentary.
    case documentary = 0

    /// News.
    case news = 1

    /// Miniseries.
    case miniseries = 2

    /// Reality.
    case reality = 3

    /// Scripted.
    case scripted = 4

    /// Talk show.
    case talkShow = 5

    /// Video.
    case video = 6

}
