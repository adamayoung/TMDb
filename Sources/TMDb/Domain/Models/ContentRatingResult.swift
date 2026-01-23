//
//  ContentRatingResult.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct ContentRatingResult: Codable, Equatable, Hashable, Sendable {
    let results: [ContentRating]
    let id: Int
}
