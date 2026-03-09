//
//  MovieReleaseType.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A movie release type used for discover filtering.
///
public enum MovieReleaseType: Int, Codable, Equatable, Hashable,
Sendable {

    /// Premiere release.
    case premiere = 1

    /// Theatrical (limited) release.
    case theatricalLimited = 2

    /// Theatrical release.
    case theatrical = 3

    /// Digital release.
    case digital = 4

    /// Physical release.
    case physical = 5

    /// TV release.
    case tv = 6

}
