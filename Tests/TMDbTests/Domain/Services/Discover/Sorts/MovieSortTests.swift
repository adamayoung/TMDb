//
//  MovieSortTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.discover))
struct MovieSortTests {

    @Test("popularity ascending description is popularity.asc")
    func popularityAscendingReturnsRawValue() {
        let sort = MovieSort.popularity(descending: false)

        #expect(sort.description == "popularity.asc")
    }

    @Test("popularity descending description is popularity.desc")
    func popularityDescendingReturnsRawValue() {
        let sort = MovieSort.popularity(descending: true)

        #expect(sort.description == "popularity.desc")
    }

    @Test("release date ascending description is release_date.asc")
    func releaseDateAscendingReturnsRawValue() {
        let sort = MovieSort.releaseDate(descending: false)

        #expect(sort.description == "release_date.asc")
    }

    @Test("release date descending description is release_date.desc")
    func releaseDateDescendingReturnsRawValue() {
        let sort = MovieSort.releaseDate(descending: true)

        #expect(sort.description == "release_date.desc")
    }

    @Test("revenue ascending description is revenue.asc")
    func revenueAscendingReturnsRawValue() {
        let sort = MovieSort.revenue(descending: false)

        #expect(sort.description == "revenue.asc")
    }

    @Test("revenue descending description is revenue.desc")
    func revenueDescendingReturnsRawValue() {
        let sort = MovieSort.revenue(descending: true)

        #expect(sort.description == "revenue.desc")
    }

    @Test("primary release date ascending description is primary_release_date.asc")
    func primaryReleaseDateAscendingAscendingReturnsRawValue() {
        let sort = MovieSort.primaryReleaseDate(descending: false)

        #expect(sort.description == "primary_release_date.asc")
    }

    @Test("primary release date descending description is primary_release_date.desc")
    func primaryReleaseDateDescendingDescendingReturnsRawValue() {
        let sort = MovieSort.primaryReleaseDate(descending: true)

        #expect(sort.description == "primary_release_date.desc")
    }

    @Test("original title ascending description is original_title.asc")
    func originalTitleAscendingReturnsRawValue() {
        let sort = MovieSort.originalTitle(descending: false)

        #expect(sort.description == "original_title.asc")
    }

    @Test("original title descending description is original_title.desc")
    func originalTitleDescendingReturnsRawValue() {
        let sort = MovieSort.originalTitle(descending: true)

        #expect(sort.description == "original_title.desc")
    }

    @Test("vote average ascending description is vote_average.asc")
    func voteAverageAscendingReturnsRawValue() {
        let sort = MovieSort.voteAverage(descending: false)

        #expect(sort.description == "vote_average.asc")
    }

    @Test("vote average descending description is vote_average.desc")
    func voteAverageDescendingReturnsRawValue() {
        let sort = MovieSort.voteAverage(descending: true)

        #expect(sort.description == "vote_average.desc")
    }

    @Test("vote count ascending description is vote_count.asc")
    func voteCountAscendingReturnsRawValue() {
        let sort = MovieSort.voteCount(descending: false)

        #expect(sort.description == "vote_count.asc")
    }

    @Test("vote count descending description is vote_count.desc")
    func voteCountDescendingReturnsRawValue() {
        let sort = MovieSort.voteCount(descending: true)

        #expect(sort.description == "vote_count.desc")
    }

}
