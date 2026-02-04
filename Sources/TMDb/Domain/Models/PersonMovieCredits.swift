//
//  PersonMovieCredits.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing movie credits for a person.
///
/// A person can be both a cast member and crew member of the same movie.
///
public struct PersonMovieCredits: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Person identifier.
    ///
    public let id: Int

    ///
    /// Movies where the person is in the cast.
    ///
    public let cast: [MovieCastCredit]

    ///
    /// Movies where the person is in the crew.
    ///
    public let crew: [MovieCrewCredit]

    ///
    /// All movies the person is in.
    ///
    @available(*, deprecated, renamed: "allMovies")
    public var allShows: [Movie] {
        allMovies
    }

    ///
    /// All movies the person is in.
    ///
    public var allMovies: [Movie] {
        let castMovies = cast.map { credit in
            Movie(
                id: credit.id,
                title: credit.title,
                originalTitle: credit.originalTitle,
                originalLanguage: credit.originalLanguage,
                overview: credit.overview,
                releaseDate: credit.releaseDate,
                posterPath: credit.posterPath,
                backdropPath: credit.backdropPath,
                popularity: credit.popularity,
                voteAverage: credit.voteAverage,
                voteCount: credit.voteCount,
                hasVideo: credit.hasVideo,
                isAdultOnly: credit.isAdultOnly
            )
        }

        let crewMovies = crew.map { credit in
            Movie(
                id: credit.id,
                title: credit.title,
                originalTitle: credit.originalTitle,
                originalLanguage: credit.originalLanguage,
                overview: credit.overview,
                releaseDate: credit.releaseDate,
                posterPath: credit.posterPath,
                backdropPath: credit.backdropPath,
                popularity: credit.popularity,
                voteAverage: credit.voteAverage,
                voteCount: credit.voteCount,
                hasVideo: credit.hasVideo,
                isAdultOnly: credit.isAdultOnly
            )
        }

        return (castMovies + crewMovies).uniqued()
    }

    /// Creates a person movie credits object.
    ///
    /// - Parameters:
    ///   - id: Person identifier
    ///   - cast: Movies where the person is in the cast.
    ///   - crew: Movies where the person is in the crew.
    ///
    public init(id: Int, cast: [MovieCastCredit], crew: [MovieCrewCredit]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
