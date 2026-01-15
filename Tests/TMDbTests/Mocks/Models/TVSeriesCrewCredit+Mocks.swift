//
//  TVSeriesCrewCredit+Mocks.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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

extension TVSeriesCrewCredit {

    static func mock(
        id: Int = 1,
        name: String = "TV Series name",
        originalName: String = "TV Series name",
        originalLanguage: String = "en",
        overview: String = "TV Series Overview",
        genreIDs: [Genre.ID] = [18, 10765],
        firstAirDate: Date? = Date(iso8601: "2020-01-15T10:20:00Z"),
        originCountries: [String] = ["US"],
        posterPath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
        backdropPath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
        popularity: Double? = 5,
        voteAverage: Double? = 7.5,
        voteCount: Int? = 200,
        isAdultOnly: Bool? = false,
        episodeCount: Int? = 8,
        job: String = "Executive Producer",
        department: String = "Production",
        creditID: String = "credit123"
    ) -> TVSeriesCrewCredit {
        TVSeriesCrewCredit(
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
            isAdultOnly: isAdultOnly,
            episodeCount: episodeCount,
            job: job,
            department: department,
            creditID: creditID
        )
    }

}

extension [TVSeriesCrewCredit] {

    static var mocks: [TVSeriesCrewCredit] {
        [
            .mock(
                id: 1, name: "TV Series 1", episodeCount: 10, job: "Director",
                department: "Directing"),
            .mock(
                id: 2, name: "TV Series 2", episodeCount: 8, job: "Producer",
                department: "Production"),
            .mock(
                id: 3, name: "TV Series 3", episodeCount: 12, job: "Writer", department: "Writing")
        ]
    }

}
