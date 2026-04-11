//
//  MovieReleaseDatesResult.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct MovieReleaseDatesResult: Equatable, Codable {

    let id: Int
    let results: [MovieReleaseDatesByCountry]

}
