//
//  File.swift
//  
//
//  Created by Daniel Chick on 6/24/24.
//

import Foundation

struct ContentRatingResult: Codable, Equatable, Hashable, Sendable {
    let results: [ContentRating]
}

public struct ContentRating: Codable, Equatable, Hashable, Sendable {
    public let descriptors: [String]
    public let country: String
    public let rating: String
}
