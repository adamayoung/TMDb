//
//  ListIntegrationTests.swift
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
    .tags(.list),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct ListIntegrationTests {

    var listService: (any ListService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.listService = TMDbClient(apiKey: apiKey).lists
    }

    @Test("details")
    func details() async throws {
        let listID = 1

        let list = try await listService.details(forList: listID, page: nil)

        #expect(list.id == listID)
        #expect(list.name == "The Marvel Universe")
        #expect(list.description != nil)
        #expect(list.createdBy == "Travis Bell")
        #expect(list.iso6391 == "en")
        #expect(list.itemCount > 0)
    }

    @Test("items")
    func items() async throws {
        let listID = 1

        let result = try await listService.items(forList: listID, page: nil)

        #expect(result.results.count > 0)
        #expect(result.page != nil)
        #expect(result.totalResults != nil)
        #expect(result.totalPages != nil)
    }

    @Test("itemStatus")
    func itemStatus() async throws {
        let listID = 1
        let movieID = 550

        let status = try await listService.itemStatus(forMedia: movieID, inList: listID)

        #expect(status.id == String(listID))
        #expect(status.isPresent == false || status.isPresent == true)
    }

}
