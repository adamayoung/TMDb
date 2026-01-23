//
//  FindIntegrationTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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

import Foundation
import Testing

@testable import TMDb

@Suite(
    .tags(.find),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct FindIntegrationTests {

    var findService: (any FindService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.findService = TMDbClient(apiKey: apiKey).find
    }

    @Test("find movie by IMDb ID")
    func findMovieByIMDbID() async throws {
        // The Shawshank Redemption
        let externalID = "tt0111161"

        let results = try await findService.find(externalID: externalID, externalSource: .imdbID)

        #expect(!results.movieResults.isEmpty)
        #expect(results.movieResults.first?.id == 278)
        #expect(results.movieResults.first?.title == "The Shawshank Redemption")
    }

    @Test("find TV series by TVDB ID")
    func findTVSeriesByTVDBID() async throws {
        // Breaking Bad
        let externalID = "81189"

        let results = try await findService.find(externalID: externalID, externalSource: .tvdbID)

        #expect(!results.tvResults.isEmpty)
        #expect(results.tvResults.first?.id == 1396)
        #expect(results.tvResults.first?.name == "Breaking Bad")
    }

    @Test("find returns empty results for non-existent ID")
    func findReturnsEmptyResultsForNonExistentID() async throws {
        let externalID = "tt0000000000"

        let results = try await findService.find(externalID: externalID, externalSource: .imdbID)

        #expect(results.movieResults.isEmpty)
        #expect(results.tvResults.isEmpty)
        #expect(results.personResults.isEmpty)
    }

}
