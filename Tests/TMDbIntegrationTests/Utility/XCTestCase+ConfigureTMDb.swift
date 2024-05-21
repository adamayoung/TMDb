//
//  XCTestCase+ConfigureTMDb.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import TMDb
import XCTest

extension XCTestCase {

    func tmdbConfiguration() throws -> TMDbConfiguration {
        try TMDbConfiguration(apiKey: tmdbAPIKey())
    }

    func tmdbCredential() throws -> Credential {
        try Self.tmdbCredential()
    }

}

extension XCTestCase {

    func tmdbAPIKey() throws -> String {
        try Self.tmdbAPIKey()
    }

    static func tmdbAPIKey() throws -> String {
        guard
            let apiKey = ProcessInfo.processInfo.environment["TMDB_API_KEY"],
            !apiKey.isEmpty
        else {
            throw XCTSkip("TMDB_API_KEY environment variable not set.")
        }

        return apiKey
    }

    private static func tmdbCredential() throws -> Credential {
        let username = try tmdbUsername()
        let password = try tmdbPassword()
        let credential = Credential(username: username, password: password)

        return credential
    }

    private static func tmdbUsername() throws -> String {
        guard
            let username = ProcessInfo.processInfo.environment["TMDB_USERNAME"],
            !username.isEmpty
        else {
            throw XCTSkip("TMDB_USERNAME environment variable not set.")
        }

        return username
    }

    private static func tmdbPassword() throws -> String {
        guard
            let password = ProcessInfo.processInfo.environment["TMDB_PASSWORD"],
            !password.isEmpty
        else {
            throw XCTSkip("TMDB_PASSWORD environment variable not set.")
        }

        return password
    }

}
