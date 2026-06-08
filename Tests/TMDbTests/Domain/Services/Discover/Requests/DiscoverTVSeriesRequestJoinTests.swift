//
//  DiscoverTVSeriesRequestJoinTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .discover))
struct DiscoverTVSeriesRequestJoinTests {

    @Test("genres with AND join produces comma-separated value")
    func genresWithAndJoinProducesCommaSeparatedValue() {
        let filter = DiscoverTVSeriesFilter()
            .withGenres([18, 10765], joinedBy: .and)
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["with_genres": "18,10765"])
    }

    @Test("genres with OR join produces pipe-separated value")
    func genresWithOrJoinProducesPipeSeparatedValue() {
        let filter = DiscoverTVSeriesFilter()
            .withGenres([18, 10765], joinedBy: .or)
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["with_genres": "18|10765"])
    }

    @Test("keywords with OR join produces pipe-separated value")
    func keywordsWithOrJoinProducesPipeSeparatedValue() {
        let filter = DiscoverTVSeriesFilter()
            .withKeywords([10, 20], joinedBy: .or)
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["with_keywords": "10|20"])
    }

    @Test("keywords with explicit AND join via fluent API produces comma-separated value")
    func keywordsWithExplicitAndJoinViaFluentAPIProducesCommaSeparatedValue() {
        let filter = DiscoverTVSeriesFilter()
            .withKeywords([10, 20], joinedBy: .and)
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["with_keywords": "10,20"])
    }

    @Test("memberwise init genres still produce comma-separated value")
    func memberwiseInitGenresStillProduceCommaSeparatedValue() {
        let filter = DiscoverTVSeriesFilter(genres: [18, 10765])
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["with_genres": "18,10765"])
    }

    @Test("memberwise init keywords still produce comma-separated value")
    func memberwiseInitKeywordsStillProduceCommaSeparatedValue() {
        let filter = DiscoverTVSeriesFilter(keywords: [10, 20])
        let request = DiscoverTVSeriesRequest(filter: filter)

        #expect(request.queryItems == ["with_keywords": "10,20"])
    }

}
