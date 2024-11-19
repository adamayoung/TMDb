//
//  TVSeriesListItem+Mocks.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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

    // swift-format-ignore: NeverForceUnwrap
    static var bigBrother: TVSeriesListItem {
        TVSeriesListItem(
            id: 11366,
            name: "Big Brother",
            originalName: "Big Brother",
            originalLanguage: "en",
            overview:
                "A British reality television game show in which a number of contestants live in an isolated house for several weeks, trying to avoid being evicted by the public with the aim of winning a large cash prize at the end of the run.",
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

    // swiftlint:enable line_length

    // swiftlint:disable line_length
    static var csi: TVSeriesListItem {
        TVSeriesListItem(
            id: 1431,
            name: "CSI: Crime Scene Investigation",
            originalName: "CSI: Crime Scene Investigation",
            originalLanguage: "en",
            overview:
                "A Las Vegas team of forensic investigators are trained to solve criminal cases by scouring the crime scene, collecting irrefutable evidence and finding the missing pieces that solve the mystery.",
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
    // swiftlint:enable line_length

}

extension [TVSeriesListItem] {

    static var mocks: [Element] {
        [
            .bigBrother,
            .csi
        ]
    }

}
