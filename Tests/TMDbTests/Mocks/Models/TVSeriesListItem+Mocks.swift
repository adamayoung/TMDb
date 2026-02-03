//
//  TVSeriesListItem+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

extension TVSeriesListItem {

    static func mock(
        id: Int = 1,
        name: String = "TV Series",
        originalName: String = "TV Series a",
        originalLanguage: String = "en",
        overview: String = "TV Series Overview",
        genreIDs: [Genre.ID] = [1],
        firstAirDate: Date? = nil,
        originCountries: [String] = ["GB"],
        posterPath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
        backdropPath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
        popularity: Double? = 5,
        voteAverage: Double? = 5,
        voteCount: Int? = 100,
        isAdultOnly: Bool? = false
    ) -> TVSeriesListItem {
        TVSeriesListItem(
            id: id,
            name: name,
            originalName: originalName,
            originalLanguage: originalLanguage,
            overview: overview,
            genreIDs: genreIDs,
            firstAirDate: firstAirDate,
            originCountries: originCountries,
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: popularity,
            voteAverage: voteAverage,
            voteCount: voteCount,
            isAdultOnly: isAdultOnly
        )
    }

    static var bigBrother: TVSeriesListItem {
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
        )
    }

    static var csi: TVSeriesListItem {
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
    }

}

extension [TVSeriesListItem] {

    static var mocks: [TVSeriesListItem] {
        [
            .bigBrother,
            .csi
        ]
    }

}
