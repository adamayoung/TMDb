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

    /// A non-movie witness that the GMT pin is not movie-shaped: `birthday`
    /// decodes through the same day-precision strategy as a release date.
    @Test("a birthday decodes to GMT midnight")
    func birthdayDecodesToGMTMidnight() async throws {
        let tomCruiseID = 500

        let person = try await personService.details(forPerson: tomCruiseID)

        let birthday = try #require(person.birthday)
        #expect(birthday.timeIntervalSince1970.truncatingRemainder(dividingBy: 86400) == 0)
        // 1962-07-03T00:00:00Z, confirmed against the live API.
        #expect(birthday == Date(timeIntervalSince1970: -236_649_600))
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
    /// The drop count is deliberately not asserted here, and that is not because
    /// of any particular unmodelled type — every value measured on this endpoint
    /// is now modelled. It is ADR-0019's carve-out: the vocabulary has never been
    /// provably closed (a 12-person sweep found three types, 30 found four, 900
    /// found five), so an exact live count would turn the weekly cron red for
    /// exactly the behaviour the library is designed to tolerate.
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

    ///
    /// Person 57755 is tagged against *True Detective* season 1 — a `tv_season`
    /// row, which was silently discarded before `TaggedImageMedia.tvSeason`
    /// existed. `showID` is asserted because it is the only field on the row
    /// that the library did not previously model at all.
    ///
    /// **This anchor is one row of twenty**, where the TV-series test above
    /// covers eighteen of twenty. `tv_season` is genuinely rare — 29 rows in a
    /// 3,386-row sweep across 900 people — so if this test starts failing, the
    /// first hypothesis is that the single user-contributed image was deleted or
    /// retagged, **not** that decoding regressed. The remedy is to re-sweep
    /// `/person/{id}/tagged_images` for another person carrying a `tv_season`
    /// row and re-point this test, not to change the decoder.
    ///
    @Test("taggedImages for a person tagged against a TV season")
    func taggedImagesForPersonTaggedAgainstTVSeason() async throws {
        let personID = 57755

        let taggedImageList = try await personService
            .taggedImages(forPerson: personID)

        #expect(!taggedImageList.results.isEmpty)

        let tvSeasons = taggedImageList.results.compactMap { taggedImage -> TVSeason? in
            guard case .tvSeason(let tvSeason) = taggedImage.media else {
                return nil
            }

            return tvSeason
        }

        let tvSeason = try #require(tvSeasons.first)
        #expect(tvSeason.showID != nil)
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
