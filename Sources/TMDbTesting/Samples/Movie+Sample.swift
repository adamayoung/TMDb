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
            id: 1,
            title: "Movie name",
            tagline: "Movie Tag Line",
            originalTitle: nil,
            originalLanguage: "en",
            originCountry: ["US"],
            overview: "Movie Overview",
            runtime: 120,
            genres: [
                Genre(id: 1, name: "Action"),
                Genre(id: 1, name: "Drama")
            ],
            releaseDate: Date(timeIntervalSince1970: 1_384_510_800),
            posterPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
            backdropPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
            budget: 1_000_000,
            revenue: 5_000_000,
            homepageURL: URL(string: "https://www.movie.com"),
            imdbID: "12345",
            status: .released,
            productionCompanies: [
                ProductionCompany(
                    id: 1,
                    name: "Production Company Name",
                    originCountry: "Production Origin Country",
                    logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
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
            popularity: 5,
            voteAverage: 6,
            voteCount: 120,
            hasVideo: false,
            isAdultOnly: false
        )
    }

}
