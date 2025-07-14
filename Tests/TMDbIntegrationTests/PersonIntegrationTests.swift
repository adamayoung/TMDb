//
//  PersonIntegrationTests.swift
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
    .tags(.person),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct PersonIntegrationTests {

    var personService: (any PersonService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.personService = TMDbClient(apiKey: apiKey).people
    }

    @Test("details")
    func details() async throws {
        let personID = 500

        let person = try await personService.details(forPerson: personID)

        #expect(person.id == personID)
        #expect(person.name == "Tom Cruise")
    }

    @Test("combinedCredits")
    func combinedCredits() async throws {
        let personID = 500

        let credits = try await personService.combinedCredits(forPerson: personID)

        #expect(credits.id == personID)
        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
    }

    @Test("movieCredits")
    func movieCredits() async throws {
        let personID = 500

        let credits = try await personService.movieCredits(forPerson: personID)

        #expect(credits.id == personID)
        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
    }

    @Test("tvSeriesCredits")
    func tvSeriesCredits() async throws {
        let personID = 500

        let credits = try await personService.tvSeriesCredits(forPerson: personID)

        #expect(credits.id == personID)
        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
    }

    @Test("images")
    func images() async throws {
        let personID = 500

        let imageCollection = try await personService.images(forPerson: personID)

        #expect(imageCollection.id == personID)
        #expect(!imageCollection.profiles.isEmpty)
    }

    @Test("popular")
    func popular() async throws {
        let personList = try await personService.popular()

        #expect(!personList.results.isEmpty)
    }

    @Test("externalLinks")
    func externalLinks() async throws {
        let personID = 115_440

        let linksCollection = try await personService.externalLinks(forPerson: personID)

        #expect(linksCollection.id == personID)
        #expect(linksCollection.imdb != nil)
        #expect(linksCollection.wikiData != nil)
        #expect(linksCollection.facebook == nil)
        #expect(linksCollection.instagram != nil)
        #expect(linksCollection.twitter != nil)
        #expect(linksCollection.tikTok != nil)
    }

}
