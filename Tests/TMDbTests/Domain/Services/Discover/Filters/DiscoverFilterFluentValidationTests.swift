//
//  DiscoverFilterFluentValidationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .discover))
struct DiscoverFilterFluentValidationTests {

    @Test("Movie withGenres with empty array leaves genres unset")
    func movieWithGenresEmptyLeavesGenresUnset() {
        let filter = DiscoverMovieFilter().withGenres([])

        #expect(filter.genres == nil)
    }

    @Test("Movie withoutGenres with empty array leaves without genres unset")
    func movieWithoutGenresEmptyLeavesUnset() {
        let filter = DiscoverMovieFilter().withoutGenres([])

        #expect(filter.withoutGenres == nil)
    }

    @Test("Movie withKeywords with empty array leaves keywords unset")
    func movieWithKeywordsEmptyLeavesUnset() {
        let filter = DiscoverMovieFilter().withKeywords([])

        #expect(filter.keywords == nil)
    }

    @Test("Movie withPeople with empty array leaves people unset")
    func movieWithPeopleEmptyLeavesUnset() {
        let filter = DiscoverMovieFilter().withPeople([])

        #expect(filter.people == nil)
    }

    @Test("Movie withCompanies with empty array leaves companies unset")
    func movieWithCompaniesEmptyLeavesUnset() {
        let filter = DiscoverMovieFilter().withCompanies([])

        #expect(filter.companies == nil)
    }

    @Test("Movie watchProviders with empty array leaves watch providers unset")
    func movieWatchProvidersEmptyLeavesUnset() {
        let filter = DiscoverMovieFilter().watchProviders([])

        #expect(filter.watchProviders == nil)
    }

    @Test("Movie originalLanguage with empty string leaves language unset")
    func movieOriginalLanguageEmptyLeavesUnset() {
        let filter = DiscoverMovieFilter().originalLanguage("")

        #expect(filter.originalLanguage == nil)
    }

    @Test("Movie originalLanguage with whitespace leaves language unset")
    func movieOriginalLanguageWhitespaceLeavesUnset() {
        let filter = DiscoverMovieFilter().originalLanguage("   ")

        #expect(filter.originalLanguage == nil)
    }

    @Test("TV series withGenres with empty array leaves genres unset")
    func tvSeriesWithGenresEmptyLeavesUnset() {
        let filter = DiscoverTVSeriesFilter().withGenres([])

        #expect(filter.genres == nil)
    }

    @Test("TV series withoutGenres with empty array leaves without genres unset")
    func tvSeriesWithoutGenresEmptyLeavesUnset() {
        let filter = DiscoverTVSeriesFilter().withoutGenres([])

        #expect(filter.withoutGenres == nil)
    }

    @Test("TV series withKeywords with empty array leaves keywords unset")
    func tvSeriesWithKeywordsEmptyLeavesUnset() {
        let filter = DiscoverTVSeriesFilter().withKeywords([])

        #expect(filter.keywords == nil)
    }

    @Test("TV series withoutKeywords with empty array leaves without keywords unset")
    func tvSeriesWithoutKeywordsEmptyLeavesUnset() {
        let filter = DiscoverTVSeriesFilter().withoutKeywords([])

        #expect(filter.withoutKeywords == nil)
    }

    @Test("TV series withNetworks with empty array leaves networks unset")
    func tvSeriesWithNetworksEmptyLeavesUnset() {
        let filter = DiscoverTVSeriesFilter().withNetworks([])

        #expect(filter.networks == nil)
    }

    @Test("TV series withCompanies with empty array leaves companies unset")
    func tvSeriesWithCompaniesEmptyLeavesUnset() {
        let filter = DiscoverTVSeriesFilter().withCompanies([])

        #expect(filter.companies == nil)
    }

    @Test("TV series watchProviders with empty array leaves watch providers unset")
    func tvSeriesWatchProvidersEmptyLeavesUnset() {
        let filter = DiscoverTVSeriesFilter().watchProviders([])

        #expect(filter.watchProviders == nil)
    }

    @Test("TV series originalLanguage with empty string leaves language unset")
    func tvSeriesOriginalLanguageEmptyLeavesUnset() {
        let filter = DiscoverTVSeriesFilter().originalLanguage("")

        #expect(filter.originalLanguage == nil)
    }

    @Test("TV series originalLanguage with whitespace leaves language unset")
    func tvSeriesOriginalLanguageWhitespaceLeavesUnset() {
        let filter = DiscoverTVSeriesFilter().originalLanguage("  \t")

        #expect(filter.originalLanguage == nil)
    }

}
