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

    @Test("queryItems with primary release date on year")
    func queryItemsWithPrimaryReleaseDateOnYear() {
        let filter = DiscoverMovieFilter(primaryReleaseYear: .on(2025))
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "primary_release_date.gte": "2025-01-01",
                "primary_release_date.lte": "2025-12-31"
            ])
    }

    @Test("queryItems with primary release date from year")
    func queryItemsWithPrimaryReleaseDateFromYear() {
        let filter = DiscoverMovieFilter(primaryReleaseYear: .from(2025))
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["primary_release_date.gte": "2025-01-01"])
    }

    @Test("queryItems with primary release date up to year")
    func queryItemsWithPrimaryReleaseDateUpToYear() {
        let filter = DiscoverMovieFilter(primaryReleaseYear: .upTo(2025))
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["primary_release_date.lte": "2025-12-31"])
    }

    @Test("queryItems with primary release date between to years")
    func queryItemsWithPrimaryReleaseDateBetweenYears() {
        let filter = DiscoverMovieFilter(primaryReleaseYear: .between(start: 2020, end: 2025))
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(
            request.queryItems == [
                "primary_release_date.gte": "2020-01-01",
                "primary_release_date.lte": "2025-12-31"
            ])
    }

    @Test("queryItems with sortedBy")
    func queryItemsWithSortedBy() {
        let request = DiscoverMoviesRequest(sortedBy: .originalTitle(descending: false))

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
            ])
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
