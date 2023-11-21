//
//  XCTestCase+ConfigureTMDb.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import TMDb
import XCTest

extension XCTestCase {

    func configureTMDb() throws {
        try TMDb.configure(TMDbConfiguration(apiKey: tmdbAPIKey()))
    }

    private func tmdbAPIKey() throws -> String {
        try Self.tmdbAPIKey()
    }

    private static func tmdbAPIKey() throws -> String {
        guard
            let apiKey = ProcessInfo.processInfo.environment["TMDB_API_KEY"],
            !apiKey.isEmpty
        else {
            throw XCTSkip("TMDB_API_KEY environment variable not set.")
        }

        return apiKey
    }

}
