//
//  SamplesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

@Suite(.tags(.testingSupport, .samples))
struct SamplesTests {

    @Test("Movie.sample is non-degenerate")
    func movieSampleIsNonDegenerate() {
        let movie = Movie.sample

        #expect(movie.id != 0)
        #expect(!movie.title.isEmpty)
    }

    @Test("Movie.sample encodes")
    func movieSampleEncodes() throws {
        _ = try JSONEncoder().encode(Movie.sample)
    }

    @Test("TVSeries.sample is non-degenerate")
    func tvSeriesSampleIsNonDegenerate() {
        let series = TVSeries.sample

        #expect(series.id != 0)
        #expect(!series.name.isEmpty)
    }

    @Test("TVSeries.sample encodes")
    func tvSeriesSampleEncodes() throws {
        _ = try JSONEncoder().encode(TVSeries.sample)
    }

    @Test("Person.sample is non-degenerate")
    func personSampleIsNonDegenerate() {
        let person = Person.sample

        #expect(person.id != 0)
        #expect(!person.name.isEmpty)
    }

    @Test("Person.sample encodes")
    func personSampleEncodes() throws {
        _ = try JSONEncoder().encode(Person.sample)
    }

    @Test("Credit.sample is non-degenerate and round-trips through Codable")
    func creditSampleRoundTrips() throws {
        let credit = Credit.sample

        #expect(!credit.id.isEmpty)

        let data = try JSONEncoder().encode(credit)
        let decoded = try JSONDecoder().decode(Credit.self, from: data)

        #expect(decoded == credit)
    }

    @Test("Network.sample is non-degenerate and round-trips through Codable")
    func networkSampleRoundTrips() throws {
        let network = Network.sample

        #expect(network.id != 0)
        #expect(!network.name.isEmpty)

        let data = try JSONEncoder().encode(network)
        let decoded = try JSONDecoder().decode(Network.self, from: data)

        #expect(decoded == network)
    }

    @Test("GuestSession.sample is non-degenerate")
    func guestSessionSampleIsNonDegenerate() {
        let session = GuestSession.sample

        #expect(session.success)
        #expect(!session.guestSessionID.isEmpty)
    }

    @Test("GuestSession.sample encodes")
    func guestSessionSampleEncodes() throws {
        _ = try JSONEncoder().encode(GuestSession.sample)
    }

    @Test("AccountDetails.sample is non-degenerate and round-trips through Codable")
    func accountDetailsSampleRoundTrips() throws {
        let account = AccountDetails.sample

        #expect(account.id != 0)
        #expect(!account.username.isEmpty)
        #expect(!account.name.isEmpty)

        let data = try JSONEncoder().encode(account)
        let decoded = try JSONDecoder().decode(AccountDetails.self, from: data)

        #expect(decoded == account)
    }

    @Test("SearchPlan.sample is non-degenerate")
    func searchPlanSampleIsNonDegenerate() throws {
        let plan = SearchPlan.sample

        let title = try #require(plan.title)
        #expect(!title.isEmpty)
        #expect(plan.isInScope)
    }

    @Test("MoviePageableList sample is non-degenerate and round-trips through Codable")
    func moviePageableListSampleRoundTrips() throws {
        let list = PageableListResult<MovieListItem>.sample

        #expect(list.page >= 1)
        #expect(!list.results.isEmpty)
        #expect(list.results.allSatisfy { $0.id != 0 })

        let data = try JSONEncoder().encode(list)
        let decoded = try JSONDecoder().decode(
            PageableListResult<MovieListItem>.self,
            from: data
        )

        #expect(decoded == list)
    }

    @Test("TranslationCollection<MovieTranslationData> sample is non-degenerate")
    func movieTranslationCollectionSampleIsNonDegenerate() {
        let collection = TranslationCollection<MovieTranslationData>.sample

        #expect(collection.id != 0)
        #expect(!collection.translations.isEmpty)
    }

    @Test("TranslationCollection<MovieTranslationData> sample encodes")
    func movieTranslationCollectionSampleEncodes() throws {
        _ = try JSONEncoder().encode(TranslationCollection<MovieTranslationData>.sample)
    }

    @Test("[Country].samples is non-empty and non-degenerate")
    func countrySamplesAreNonDegenerate() {
        let countries = [Country].samples

        #expect(!countries.isEmpty)
        #expect(countries.allSatisfy { !$0.countryCode.isEmpty })
        #expect(countries.allSatisfy { !$0.name.isEmpty })
    }

    @Test("[WatchProvider].samples is non-empty and non-degenerate")
    func watchProviderSamplesAreNonDegenerate() {
        let providers = [WatchProvider].samples

        #expect(!providers.isEmpty)
        #expect(providers.allSatisfy { $0.id != 0 })
        #expect(providers.allSatisfy { !$0.name.isEmpty })
    }

}
