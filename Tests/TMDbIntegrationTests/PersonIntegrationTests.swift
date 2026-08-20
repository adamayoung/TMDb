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
    .integrationGate,
    .serialized,
    .tags(.person),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct PersonIntegrationTests {

    var personService: (any PersonService)!

    init() {
        self.personService = CredentialHelper.shared.makeClient().people
    }

    @Test("details")
    func details() async throws {
        let personID = 500

        let person = try await personService.details(forPerson: personID)

        #expect(person.id == personID)
        #expect(person.name == "Tom Cruise")
        #expect(person.isAdultOnly != nil)
    }

    @Test("combinedCredits")
    func combinedCredits() async throws {
        let personID = 500

        let credits = try await personService.combinedCredits(forPerson: personID)

        #expect(credits.id == personID)
        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
        // Combined credits are the one credits shape whose elements carry a
        // `media_type`. A non-zero count here means TMDb has started sending one
        // this library does not model.
        #expect(credits.droppedItemCount == 0)
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

    ///
    /// Person 500 is tagged almost entirely in movies, so the test above never
    /// exercised a TV series. Person 17419 is the opposite — most of page one is
    /// tagged against the series rather than an episode of it, and every one of
    /// those rows was silently discarded before `TaggedImageMedia.tvSeries`
    /// existed.
    ///
    /// The drop count is deliberately not asserted here. `tv_season` also occurs
    /// on this endpoint and is still unmodelled, so an exact count against live
    /// data would fail for something the library is designed to skip.
    ///
    @Test("taggedImages for a person tagged against whole TV series")
    func taggedImagesForPersonTaggedAgainstTVSeries() async throws {
        let personID = 17419

        let taggedImageList = try await personService
            .taggedImages(forPerson: personID)

        #expect(!taggedImageList.results.isEmpty)
        #expect(
            taggedImageList.results.contains {
                if case .tvSeries = $0.media { true } else { false }
            }
        )
    }

    @Test("translations")
    func translations() async throws {
        let personID = 500

        let translationCollection = try await personService
            .translations(forPerson: personID)

        #expect(translationCollection.id == personID)
        #expect(!translationCollection.translations.isEmpty)
    }

    @Test("changes")
    func changes() async throws {
        let personID = 500

        _ = try await personService
            .changes(forPerson: personID)
    }

    @Test("latestPerson")
    func latestPerson() async throws {
        let person = try await personService.latest()

        #expect(person.id > 0)
    }

    @Test("personChanges")
    func personChanges() async throws {
        let changedIDCollection = try await personService
            .changes()

        #expect(changedIDCollection.page > 0)
        #expect(changedIDCollection.totalResults > 0)
    }

    @Test("details with appended credits and images")
    func detailsWithAppendedData() async throws {
        let personID = 500

        let result = try await personService.details(
            forPerson: personID,
            appending: [.movieCredits, .images]
        )

        #expect(result.person.id == personID)
        #expect(result.person.name == "Tom Cruise")
        let movieCredits = try #require(result.movieCredits)
        #expect(movieCredits.id == personID)
        #expect(!movieCredits.cast.isEmpty)
        let images = try #require(result.images)
        #expect(images.id == personID)
    }

}
