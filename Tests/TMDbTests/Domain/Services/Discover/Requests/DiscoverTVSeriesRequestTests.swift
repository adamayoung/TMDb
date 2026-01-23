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
        let request = DiscoverTVSeriesRequest(sortedBy: .firstAirDate(descending: false))

        #expect(request.queryItems == ["sort_by": "first_air_date.asc"])
    }

    @Test("queryItems with page")
    func queryItemsWithPage() throws {
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
            ])
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
