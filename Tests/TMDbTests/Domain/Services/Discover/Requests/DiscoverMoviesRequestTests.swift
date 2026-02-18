//
//  DiscoverMoviesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .discover))
struct DiscoverMoviesRequestTests {

    @Test("path is correct")
    func path() {
        let request = DiscoverMoviesRequest()

        #expect(request.path == "/discover/movie")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = DiscoverMoviesRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with people")
    func queryItemsWithPeople() {
        let filter = DiscoverMovieFilter(people: [1, 2, 3])
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["with_people": "1,2,3"])
    }

    @Test("queryItems with original language")
    func queryItemsWithOriginalLanguage() {
        let filter = DiscoverMovieFilter(originalLanguage: "en")
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["with_original_language": "en"])
    }

    @Test("queryItems with genres")
    func queryItemsWithGenres() {
        let filter = DiscoverMovieFilter(genres: [1, 2, 3])
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["with_genres": "1,2,3"])
    }

    @Test("queryItems with without genres")
    func queryItemsWithWithoutGenres() {
        let filter = DiscoverMovieFilter(withoutGenres: [27, 53])
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["without_genres": "27,53"])
    }

    @Test("queryItems with primary release date on year")
    func queryItemsWithPrimaryReleaseDateOnYear() {
        let filter = DiscoverMovieFilter(primaryReleaseYear: .on(2025))
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "primary_release_date.gte": "2025-01-01",
                "primary_release_date.lte": "2025-12-31"
            ]
        )
    }

    @Test("queryItems with primary release date from year")
    func queryItemsWithPrimaryReleaseDateFromYear() {
        let filter = DiscoverMovieFilter(primaryReleaseYear: .from(2025))
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(
            request.queryItems == ["primary_release_date.gte": "2025-01-01"]
        )
    }

    @Test("queryItems with primary release date up to year")
    func queryItemsWithPrimaryReleaseDateUpToYear() {
        let filter = DiscoverMovieFilter(primaryReleaseYear: .upTo(2025))
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(
            request.queryItems == ["primary_release_date.lte": "2025-12-31"]
        )
    }

    @Test("queryItems with primary release date between years")
    func queryItemsWithPrimaryReleaseDateBetweenYears() {
        let filter = DiscoverMovieFilter(
            primaryReleaseYear: .between(start: 2020, end: 2025)
        )
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "primary_release_date.gte": "2020-01-01",
                "primary_release_date.lte": "2025-12-31"
            ]
        )
    }

    @Test("queryItems with vote average range")
    func queryItemsWithVoteAverageRange() {
        let filter = DiscoverMovieFilter(
            voteAverageMin: 7.0,
            voteAverageMax: 10.0
        )
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "vote_average.gte": "7.0",
                "vote_average.lte": "10.0"
            ]
        )
    }

    @Test("queryItems with vote count range")
    func queryItemsWithVoteCountRange() {
        let filter = DiscoverMovieFilter(
            voteCountMin: 100,
            voteCountMax: 1000
        )
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "vote_count.gte": "100",
                "vote_count.lte": "1000"
            ]
        )
    }

    @Test("queryItems with companies")
    func queryItemsWithCompanies() {
        let filter = DiscoverMovieFilter(companies: [1, 2])
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["with_companies": "1,2"])
    }

    @Test("queryItems with keywords")
    func queryItemsWithKeywords() {
        let filter = DiscoverMovieFilter(keywords: [10, 20])
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["with_keywords": "10,20"])
    }

    @Test("queryItems with without keywords")
    func queryItemsWithWithoutKeywords() {
        let filter = DiscoverMovieFilter(withoutKeywords: [30, 40])
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["without_keywords": "30,40"])
    }

    @Test("queryItems with runtime range")
    func queryItemsWithRuntimeRange() {
        let filter = DiscoverMovieFilter(runtimeMin: 90, runtimeMax: 180)
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "with_runtime.gte": "90",
                "with_runtime.lte": "180"
            ]
        )
    }

    @Test("queryItems with include adult")
    func queryItemsWithIncludeAdult() {
        let filter = DiscoverMovieFilter(includeAdult: true)
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["include_adult": "true"])
    }

    @Test("queryItems with include video")
    func queryItemsWithIncludeVideo() {
        let filter = DiscoverMovieFilter(includeVideo: true)
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["include_video": "true"])
    }

    @Test("queryItems with watch providers and region")
    func queryItemsWithWatchProvidersAndRegion() {
        let filter = DiscoverMovieFilter(
            watchProviders: [8, 9],
            watchRegion: "US"
        )
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "with_watch_providers": "8,9",
                "watch_region": "US"
            ]
        )
    }

    @Test("queryItems with sortedBy")
    func queryItemsWithSortedBy() {
        let request = DiscoverMoviesRequest(
            sortedBy: .originalTitle(descending: false)
        )

        #expect(request.queryItems == ["sort_by": "original_title.asc"])
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = DiscoverMoviesRequest(page: 1)

        #expect(request.queryItems == ["page": "1"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = DiscoverMoviesRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with sortedBy, people, page and language")
    func queryItemsWithSortedByAndPeopleAndPageAndLanguage() {
        let filter = DiscoverMovieFilter(people: [1, 2, 3])

        let request = DiscoverMoviesRequest(
            filter: filter,
            sortedBy: .originalTitle(descending: false),
            page: 2,
            language: "en"
        )

        #expect(
            request.queryItems == [
                "sort_by": "original_title.asc",
                "with_people": "1,2,3",
                "page": "2",
                "language": "en"
            ]
        )
    }

    @Test("queryItems with multiple filter parameters")
    func queryItemsWithMultipleFilterParameters() {
        let filter = DiscoverMovieFilter(
            voteAverageMin: 7.0,
            voteAverageMax: 9.0,
            companies: [420, 7505],
            keywords: [9715, 180_547],
            runtimeMin: 90,
            runtimeMax: 180
        )
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "vote_average.gte": "7.0",
                "vote_average.lte": "9.0",
                "with_companies": "420,7505",
                "with_keywords": "9715,180547",
                "with_runtime.gte": "90",
                "with_runtime.lte": "180"
            ]
        )
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = DiscoverMoviesRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = DiscoverMoviesRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = DiscoverMoviesRequest()

        #expect(request.body == nil)
    }

}
