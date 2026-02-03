//
//  TVSeriesPageableListTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVSeriesPageableListTests {

    @Test("JSON decoding of TVSeriesPageableList", .tags(.decoding))
    func decodeReturnsTVSeriesPageableList() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(TVSeriesPageableList.self, fromResource: "tv-series-pageable-list")

        #expect(result.page == list.page)
        #expect(result.results == list.results)
        #expect(result.totalResults == list.totalResults)
        #expect(result.totalPages == list.totalPages)
    }

    private let list = TVSeriesPageableList(
        page: 1,
        results: [
            TVSeriesListItem(
                id: 11366,
                name: "Big Brother",
                originalName: "Big Brother",
                originalLanguage: "en",
                // swiftlint:disable:next line_length
                overview: "A British reality television game show in which a number of contestants live in an isolated house for several weeks, trying to avoid being evicted by the public with the aim of winning a large cash prize at the end of the run.",
                genreIDs: [10764],
                firstAirDate: DateFormatter.theMovieDatabase.date(from: "2000-07-18"),
                originCountries: ["GB"],
                posterPath: URL(string: "/p7lsmCU5ZqaMGKZAuZMkFc02X8o.jpg"),
                backdropPath: URL(string: "/3SWOj8ydFrxiuZdLg63fDAt4jYR.jpg"),
                popularity: 5434.15,
                voteAverage: 3.833,
                voteCount: 48,
                isAdultOnly: false
            ),
            TVSeriesListItem(
                id: 1431,
                name: "CSI: Crime Scene Investigation",
                originalName: "CSI: Crime Scene Investigation",
                originalLanguage: "en",
                // swiftlint:disable:next line_length
                overview: "A Las Vegas team of forensic investigators are trained to solve criminal cases by scouring the crime scene, collecting irrefutable evidence and finding the missing pieces that solve the mystery.",
                genreIDs: [80, 18, 9648],
                firstAirDate: DateFormatter.theMovieDatabase.date(from: "2000-10-06"),
                originCountries: ["US"],
                posterPath: URL(string: "/i5hmoRjHNWady4AtAGICTUXknKH.jpg"),
                backdropPath: URL(string: "/vZePKXaSO3537aJTxifE3Rrwobb.jpg"),
                popularity: 4140.812,
                voteAverage: 7.619,
                voteCount: 1178,
                isAdultOnly: false
            )
        ],
        totalResults: 2,
        totalPages: 1
    )

}
