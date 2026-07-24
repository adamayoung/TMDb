//
//  Movie+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension Movie {

    /// A sample `Movie` for use in tests and previews.
    static var sample: Movie {
        Movie(
            id: 550,
            title: "Fight Club",
            tagline: "Mischief. Mayhem. Soap.",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            originCountry: ["US"],
            overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel "
                + "primal male aggression into a shocking new form of therapy. Their concept "
                + "catches on, with underground \"fight clubs\" forming in every town, until an "
                + "eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
            runtime: .seconds(139 * 60),
            genres: [
                Genre(id: 18, name: "Drama"),
                Genre(id: 53, name: "Thriller")
            ],
            releaseDate: Date(timeIntervalSince1970: 939_945_600),
            posterPath: URL(string: "/jSziioSwPVrOy9Yow3XhWIBDjq1.jpg"),
            backdropPath: URL(string: "/c6OLXfKAk5BKeR6broC8pYiCquX.jpg"),
            budget: 63_000_000,
            revenue: 100_853_753,
            homepageURL: URL(string: "https://www.20thcenturystudios.com/movies/fight-club"),
            imdbID: "tt0137523",
            status: .released,
            productionCompanies: [
                ProductionCompany(
                    id: 711,
                    name: "Fox 2000 Pictures",
                    originCountry: "US",
                    logoPath: URL(string: "/tEiIH5QesdheJmDAqQwvtN60727.png")
                )
            ],
            productionCountries: [
                ProductionCountry(
                    countryCode: "US",
                    name: "United States of America"
                )
            ],
            spokenLanguages: [
                SpokenLanguage(languageCode: "en", name: "English")
            ],
            belongsToCollection: nil,
            popularity: 25.5667,
            voteAverage: 8.438,
            voteCount: 32197,
            hasVideo: false,
            isAdultOnly: false
        )
    }

}
