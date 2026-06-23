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
        let posterPath = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")

        let movie = Movie(
            id: 718_930,
            title: "Bullet Train",
            tagline: "Movie Tag Line",
            originalLanguage: "en",
            originCountry: ["US"],
            overview: "Movie Overview",
            runtime: 120,
            genres: [Genre(id: 28, name: "Action")],
            releaseDate: Date(timeIntervalSince1970: 1_384_510_800),
            posterPath: posterPath,
            backdropPath: posterPath,
            budget: 1_000_000,
            revenue: 5_000_000,
            homepageURL: URL(string: "https://www.movie.com"),
            imdbID: "12345",
            status: .released,
            popularity: 5,
            voteAverage: 6,
            voteCount: 120,
            hasVideo: false,
            isAdultOnly: false
        )

        let image = ImageMetadata(
            filePath: posterPath ?? URL(fileURLWithPath: "/"),
            width: 100,
            height: 100,
            aspectRatio: 1,
            voteAverage: 5,
            voteCount: 100,
            languageCode: "en"
        )

        let images = ImageCollection(
            id: movie.id,
            posters: [image],
            logos: [image],
            backdrops: [image]
        )

        return MovieDetailsResponse(movie: movie, images: images)
    }

}
