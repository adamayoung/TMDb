//
//  ShowWatchProviderResult.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct ShowWatchProviderResult: Equatable, Codable {

    let id: Int
    let results: [String: ShowWatchProvider]

}
