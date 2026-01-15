//
//  CollectionIntegrationTests.swift
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
    .tags(.collection),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct CollectionIntegrationTests {

    var collectionService: (any CollectionService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.collectionService = TMDbClient(apiKey: apiKey).collections
    }

    @Test("details")
    func details() async throws {
        let collectionID = 10

        let collection = try await collectionService.details(
            forCollection: collectionID,
            language: nil
        )

        #expect(collection.id == collectionID)
        #expect(collection.name == "Star Wars Collection")
        #expect(!collection.parts.isEmpty)
    }

    @Test("details with language")
    func detailsWithLanguage() async throws {
        let collectionID = 10
        let language = "de"

        let collection = try await collectionService.details(
            forCollection: collectionID,
            language: language
        )

        #expect(collection.id == collectionID)
        #expect(collection.name.contains("Star Wars"))
    }

    @Test("images")
    func images() async throws {
        let collectionID = 10

        let imageCollection = try await collectionService.images(
            forCollection: collectionID,
            languages: nil
        )

        #expect(imageCollection.id == collectionID)
        #expect(!imageCollection.posters.isEmpty)
        #expect(!imageCollection.backdrops.isEmpty)
    }

    @Test("images with languages")
    func imagesWithLanguages() async throws {
        let collectionID = 10
        let languages = ["en", "de"]

        let imageCollection = try await collectionService.images(
            forCollection: collectionID,
            languages: languages
        )

        #expect(imageCollection.id == collectionID)
        #expect(!imageCollection.posters.isEmpty)
    }

    @Test("translations", .disabled("Known issue - needs investigation"))
    func translations() async throws {
        let collectionID = 10

        do {
            let translations = try await collectionService.translations(
                forCollection: collectionID
            )

            #expect(!translations.isEmpty)
            #expect(translations.contains(where: { $0.languageCode == "en" }))
        } catch {
            Issue.record("Failed with error: \(error)")
            throw error
        }
    }

}
