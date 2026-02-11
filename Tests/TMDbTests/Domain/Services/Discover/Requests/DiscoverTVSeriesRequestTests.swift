//
//  DiscoverTVSeriesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .discover))
struct DiscoverTVSeriesRequestTests {

    @Test("path is correct")
    func path() {
        let request = DiscoverTVSeriesRequest()

        #expect(request.path == "/discover/tv")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = DiscoverTVSeriesRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with sortedBy")
    func queryItemsWithSortedBy() {
        let request = DiscoverTVSeriesRequest(
            sortedBy: .firstAirDate(descending: false)
        )

        #expect(request.queryItems == ["sort_by": "first_air_date.asc"])
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = DiscoverTVSeriesRequest(page: 1)

        #expect(request.queryItems == ["page": "1"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = DiscoverTVSeriesRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with original language")
    func queryItemsWithOriginalLanguage() {
        let filter = DiscoverTVSeriesFilter(originalLanguage: "en")
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["with_original_language": "en"])
    }

    @Test("queryItems with genres")
    func queryItemsWithGenres() {
        let filter = DiscoverTVSeriesFilter(genres: [1, 2, 3])
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["with_genres": "1,2,3"])
    }

    @Test("queryItems with without genres")
    func queryItemsWithWithoutGenres() {
        let filter = DiscoverTVSeriesFilter(withoutGenres: [27, 53])
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["without_genres": "27,53"])
    }

    @Test("queryItems with first air date year")
    func queryItemsWithFirstAirDateYear() {
        let filter = DiscoverTVSeriesFilter(firstAirDateYear: 2024)
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(
            request.queryItems == ["first_air_date_year": "2024"]
        )
    }

    @Test("queryItems with first air date range")
    func queryItemsWithFirstAirDateRange() {
        let filter = DiscoverTVSeriesFilter(
            firstAirDateMin: Date(iso8601: "2024-01-01T00:00:00Z"),
            firstAirDateMax: Date(iso8601: "2024-12-31T00:00:00Z")
        )
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "first_air_date.gte": "2024-01-01",
                "first_air_date.lte": "2024-12-31"
            ]
        )
    }

    @Test("queryItems with air date range")
    func queryItemsWithAirDateRange() {
        let filter = DiscoverTVSeriesFilter(
            airDateMin: Date(iso8601: "2024-06-01T00:00:00Z"),
            airDateMax: Date(iso8601: "2024-06-30T00:00:00Z")
        )
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "air_date.gte": "2024-06-01",
                "air_date.lte": "2024-06-30"
            ]
        )
    }

    @Test("queryItems with vote average range")
    func queryItemsWithVoteAverageRange() {
        let filter = DiscoverTVSeriesFilter(
            voteAverageMin: 7.0,
            voteAverageMax: 10.0
        )
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "vote_average.gte": "7.0",
                "vote_average.lte": "10.0"
            ]
        )
    }

    @Test("queryItems with vote count range")
    func queryItemsWithVoteCountRange() {
        let filter = DiscoverTVSeriesFilter(
            voteCountMin: 100,
            voteCountMax: 1000
        )
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "vote_count.gte": "100",
                "vote_count.lte": "1000"
            ]
        )
    }

    @Test("queryItems with networks")
    func queryItemsWithNetworks() {
        let filter = DiscoverTVSeriesFilter(networks: [213, 1024])
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["with_networks": "213,1024"])
    }

    @Test("queryItems with companies")
    func queryItemsWithCompanies() {
        let filter = DiscoverTVSeriesFilter(companies: [1, 2])
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["with_companies": "1,2"])
    }

    @Test("queryItems with keywords")
    func queryItemsWithKeywords() {
        let filter = DiscoverTVSeriesFilter(keywords: [10, 20])
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["with_keywords": "10,20"])
    }

    @Test("queryItems with without keywords")
    func queryItemsWithWithoutKeywords() {
        let filter = DiscoverTVSeriesFilter(withoutKeywords: [30, 40])
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["without_keywords": "30,40"])
    }

    @Test("queryItems with runtime range")
    func queryItemsWithRuntimeRange() {
        let filter = DiscoverTVSeriesFilter(
            runtimeMin: 30,
            runtimeMax: 60
        )
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "with_runtime.gte": "30",
                "with_runtime.lte": "60"
            ]
        )
    }

    @Test("queryItems with include adult")
    func queryItemsWithIncludeAdult() {
        let filter = DiscoverTVSeriesFilter(includeAdult: true)
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["include_adult": "true"])
    }

    @Test("queryItems with watch providers and region")
    func queryItemsWithWatchProvidersAndRegion() {
        let filter = DiscoverTVSeriesFilter(
            watchProviders: [8, 9],
            watchRegion: "US"
        )
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "with_watch_providers": "8,9",
                "watch_region": "US"
            ]
        )
    }

    @Test("queryItems with sortedBy, page and language")
    func queryItemsWithSortedByAndPageAndLanguage() {
        let request = DiscoverTVSeriesRequest(
            sortedBy: .firstAirDate(descending: false),
            page: 2,
            language: "en"
        )

        #expect(
            request.queryItems == [
                "sort_by": "first_air_date.asc",
                "page": "2",
                "language": "en"
            ]
        )
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = DiscoverTVSeriesRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = DiscoverTVSeriesRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = DiscoverTVSeriesRequest()

        #expect(request.body == nil)
    }

}
