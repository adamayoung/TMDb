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
        let castCredit = TVSeriesCastCredit(
            id: 54,
            name: "Growing Pains",
            originalName: "Growing Pains",
            originalLanguage: "en",
            overview: "Fatherhood has taken on a whole new meaning for Jason Seaver, who has "
                + "assumed the chores of cooking, cleaning and minding the kids so that his "
                + "wife, Maggie, can pursue a career in journalism after spending 15 years "
                + "as a housewife.",
            genreIDs: [35],
            firstAirDate: Date(timeIntervalSince1970: 496_368_000),
            originCountries: ["US"],
            posterPath: URL(string: "/dhzttMAkFTFAax2CTBAql1CaaXB.jpg"),
            backdropPath: URL(string: "/rwr4VtrwuUuRbIGz5Nar0QmPoNO.jpg"),
            popularity: 12.5367,
            voteAverage: 6.5,
            voteCount: 169,
            isAdultOnly: false,
            episodeCount: 1,
            character: "Jeff",
            creditID: "525333fb19c295794002c720"
        )

        let crewCredit = TVSeriesCrewCredit(
            id: 69061,
            name: "The OA",
            originalName: "The OA",
            originalLanguage: "en",
            overview: "Seven years after vanishing from her home, a young woman returns with "
                + "mysterious new abilities and recruits five strangers for a secret mission.",
            genreIDs: [10765, 9648, 18],
            firstAirDate: Date(timeIntervalSince1970: 1_481_846_400),
            originCountries: ["US"],
            posterPath: URL(string: "/rueY4slMeKtTGitm0raFUJvgaa5.jpg"),
            backdropPath: URL(string: "/hsSFJ7WyVTNU87c06KFVesntrUQ.jpg"),
            popularity: 11.8629,
            voteAverage: 7.509,
            voteCount: 1374,
            isAdultOnly: false,
            episodeCount: 16,
            job: "Executive Producer",
            department: "Production",
            creditID: "58cf92ae9251415a7d0339c3"
        )

        return PersonTVSeriesCredits(id: 287, cast: [castCredit], crew: [crewCredit])
    }

}
