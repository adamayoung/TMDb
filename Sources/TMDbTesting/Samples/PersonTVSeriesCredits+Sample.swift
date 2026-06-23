//
//  PersonTVSeriesCredits+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension PersonTVSeriesCredits {

    ///
    /// A sample person TV series credits, for use in tests and previews.
    ///
    static var sample: PersonTVSeriesCredits {
        let posterPath = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
        let firstAirDate = Date(timeIntervalSince1970: 1_579_084_800)

        let castCredit = TVSeriesCastCredit(
            id: 1,
            name: "TV Series name",
            originalName: "TV Series name",
            originalLanguage: "en",
            overview: "TV Series Overview",
            genreIDs: [18, 10765],
            firstAirDate: firstAirDate,
            originCountries: ["US"],
            posterPath: posterPath,
            backdropPath: posterPath,
            popularity: 5,
            voteAverage: 7.5,
            voteCount: 200,
            isAdultOnly: false,
            episodeCount: 10,
            character: "Character Name",
            creditID: "credit123"
        )

        let crewCredit = TVSeriesCrewCredit(
            id: 1,
            name: "TV Series name",
            originalName: "TV Series name",
            originalLanguage: "en",
            overview: "TV Series Overview",
            genreIDs: [18, 10765],
            firstAirDate: firstAirDate,
            originCountries: ["US"],
            posterPath: posterPath,
            backdropPath: posterPath,
            popularity: 5,
            voteAverage: 7.5,
            voteCount: 200,
            isAdultOnly: false,
            episodeCount: 8,
            job: "Executive Producer",
            department: "Production",
            creditID: "credit123"
        )

        return PersonTVSeriesCredits(id: 1, cast: [castCredit], crew: [crewCredit])
    }

}
