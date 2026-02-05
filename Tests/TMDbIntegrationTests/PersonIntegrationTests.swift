//
//  PersonIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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

    @Test("taggedImages")
    func taggedImages() async throws {
        let personID = 500

        let taggedImageList = try await personService
            .taggedImages(forPerson: personID)

        #expect(!taggedImageList.results.isEmpty)
    }

    @Test("translations")
    func translations() async throws {
        let personID = 500

        let translationCollection = try await personService
            .translations(forPerson: personID)

        #expect(translationCollection.id == personID)
        #expect(!translationCollection.translations.isEmpty)
    }

}
