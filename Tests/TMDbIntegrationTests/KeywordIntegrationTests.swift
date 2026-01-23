//
//  KeywordIntegrationTests.swift
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
    .tags(.keyword),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct KeywordIntegrationTests {

    var keywordService: (any KeywordService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.keywordService = TMDbClient(apiKey: apiKey).keywords
    }

    @Test("details")
    func details() async throws {
        let keywordID = 378

        let keyword = try await keywordService.details(forKeyword: keywordID)

        #expect(keyword.id == keywordID)
        #expect(keyword.name == "prison")
    }

    @Test("movies")
    func movies() async throws {
        let keywordID = 378

        let movieList = try await keywordService.movies(forKeyword: keywordID)

        #expect(movieList.results.isEmpty == false)
        #expect((movieList.page ?? 0) >= 1)
        #expect((movieList.totalResults ?? 0) >= 1)
    }

    @Test("movies with page and language")
    func moviesWithPageAndLanguage() async throws {
        let keywordID = 378

        let movieList = try await keywordService.movies(
            forKeyword: keywordID,
            page: 1,
            language: "en"
        )

        #expect(movieList.results.isEmpty == false)
        #expect(movieList.page == 1)
    }

}
