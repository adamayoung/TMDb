//
//  MovieDetailsResponse+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension MovieDetailsResponse {

    ///
    /// A sample movie details response, for use in tests and previews.
    ///
    static var sample: MovieDetailsResponse {
        let posterPath = URL(string: "/jSziioSwPVrOy9Yow3XhWIBDjq1.jpg")
        let backdropPath = URL(string: "/c6OLXfKAk5BKeR6broC8pYiCquX.jpg")

        let movie = Movie(
            id: 550,
            title: "Fight Club",
            tagline: "Mischief. Mayhem. Soap.",
            originalLanguage: "en",
            originCountry: ["US"],
            overview: """
            A ticking-time-bomb insomniac and a slippery soap salesman channel primal male \
            aggression into a shocking new form of therapy. Their concept catches on, with \
            underground "fight clubs" forming in every town, until an eccentric gets in the \
            way and ignites an out-of-control spiral toward oblivion.
            """,
            runtime: 139,
            genres: [Genre(id: 18, name: "Drama")],
            releaseDate: Date(timeIntervalSince1970: 939_945_600),
            posterPath: posterPath,
            backdropPath: backdropPath,
            budget: 63_000_000,
            revenue: 100_853_753,
            homepageURL: URL(string: "https://www.20thcenturystudios.com/movies/fight-club"),
            imdbID: "tt0137523",
            status: .released,
            popularity: 25.5667,
            voteAverage: 8.438,
            voteCount: 32197,
            hasVideo: false,
            isAdultOnly: false
        )

        let poster = ImageMetadata(
            filePath: URL(string: "/nu7FEmC4zBaZ7c3QYmVpDlZa2H0.jpg") ?? URL(fileURLWithPath: "/"),
            width: 2000,
            height: 3000,
            aspectRatio: 0.667,
            voteAverage: 5.928,
            voteCount: 21,
            languageCode: "pt"
        )

        let backdrop = ImageMetadata(
            filePath: backdropPath ?? URL(fileURLWithPath: "/"),
            width: 2560,
            height: 1440,
            aspectRatio: 1.778,
            voteAverage: 6.14,
            voteCount: 32,
            languageCode: nil
        )

        let logo = ImageMetadata(
            filePath: URL(string: "/7Uqhv24pGJs4Ns31NoOPWFJGWNG.png") ?? URL(fileURLWithPath: "/"),
            width: 1804,
            height: 389,
            aspectRatio: 4.638,
            voteAverage: 8.034,
            voteCount: 5,
            languageCode: "en"
        )

        let images = ImageCollection(
            id: movie.id,
            posters: [poster],
            logos: [logo],
            backdrops: [backdrop]
        )

        return MovieDetailsResponse(movie: movie, images: images)
    }

}
