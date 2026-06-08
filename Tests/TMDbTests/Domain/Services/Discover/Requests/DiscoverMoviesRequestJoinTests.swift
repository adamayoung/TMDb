//
//  DiscoverMoviesRequestJoinTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .discover))
struct DiscoverMoviesRequestJoinTests {

    @Test("genres with AND join produces comma-separated value")
    func genresWithAndJoinProducesCommaSeparatedValue() {
        let filter = DiscoverMovieFilter().withGenres([28, 12], joinedBy: .and)
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["with_genres": "28,12"])
    }

    @Test("genres with OR join produces pipe-separated value")
    func genresWithOrJoinProducesPipeSeparatedValue() {
        let filter = DiscoverMovieFilter().withGenres([28, 12], joinedBy: .or)
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["with_genres": "28|12"])
    }

    @Test("keywords with OR join produces pipe-separated value")
    func keywordsWithOrJoinProducesPipeSeparatedValue() {
        let filter = DiscoverMovieFilter()
            .withKeywords([10, 20], joinedBy: .or)
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["with_keywords": "10|20"])
    }

    @Test("keywords with explicit AND join via fluent API produces comma-separated value")
    func keywordsWithExplicitAndJoinViaFluentAPIProducesCommaSeparatedValue() {
        let filter = DiscoverMovieFilter()
            .withKeywords([10, 20], joinedBy: .and)
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["with_keywords": "10,20"])
    }

    @Test("memberwise init genres still produce comma-separated value")
    func memberwiseInitGenresStillProduceCommaSeparatedValue() {
        let filter = DiscoverMovieFilter(genres: [28, 12])
        let request = DiscoverMoviesRequest(filter: filter)

        // Regression: existing memberwise-init path defaults to AND (comma)
        // exactly as before the fluent layer was added.
        #expect(request.queryItems == ["with_genres": "28,12"])
    }

    @Test("memberwise init keywords still produce comma-separated value")
    func memberwiseInitKeywordsStillProduceCommaSeparatedValue() {
        let filter = DiscoverMovieFilter(keywords: [10, 20])
        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems == ["with_keywords": "10,20"])
    }

}
