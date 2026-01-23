//
//  PersonCombinedCredits.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing combined movie and TV series credits for a person.
///
/// A person can be both a cast member and crew member of the same show.
///
public struct PersonCombinedCredits: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Person identifier.
    ///
    public let id: Int

    ///
    /// Shows where the person is in the cast.
    ///
    public let cast: [ShowCastCredit]

    ///
    /// Shows where the person is in the crew.
    ///
    public let crew: [ShowCrewCredit]

    ///
    /// All shows the person is in.
    ///
    public var allShows: [Show] {
        let castShows = cast.map { credit -> Show in
            switch credit {
            case .movie(let movieCredit):
                return .movie(
                    MovieListItem(
                        id: movieCredit.id,
                        title: movieCredit.title,
                        originalTitle: movieCredit.originalTitle,
                        originalLanguage: movieCredit.originalLanguage,
                        overview: movieCredit.overview,
                        genreIDs: movieCredit.genreIDs,
                        releaseDate: movieCredit.releaseDate,
                        posterPath: movieCredit.posterPath,
                        backdropPath: movieCredit.backdropPath,
                        popularity: movieCredit.popularity,
                        voteAverage: movieCredit.voteAverage,
                        voteCount: movieCredit.voteCount,
                        hasVideo: movieCredit.hasVideo,
                        isAdultOnly: movieCredit.isAdultOnly
                    )
                )
            case .tvSeries(let tvCredit):
                return .tvSeries(
                    TVSeriesListItem(
                        id: tvCredit.id,
                        name: tvCredit.name,
                        originalName: tvCredit.originalName,
                        originalLanguage: tvCredit.originalLanguage,
                        overview: tvCredit.overview,
                        genreIDs: tvCredit.genreIDs,
                        firstAirDate: tvCredit.firstAirDate,
                        originCountries: tvCredit.originCountries,
                        posterPath: tvCredit.posterPath,
                        backdropPath: tvCredit.backdropPath,
                        popularity: tvCredit.popularity,
                        voteAverage: tvCredit.voteAverage,
                        voteCount: tvCredit.voteCount,
                        isAdultOnly: tvCredit.isAdultOnly
                    )
                )
            }
        }

        let crewShows = crew.map { credit -> Show in
            switch credit {
            case .movie(let movieCredit):
                return .movie(
                    MovieListItem(
                        id: movieCredit.id,
                        title: movieCredit.title,
                        originalTitle: movieCredit.originalTitle,
                        originalLanguage: movieCredit.originalLanguage,
                        overview: movieCredit.overview,
                        genreIDs: movieCredit.genreIDs,
                        releaseDate: movieCredit.releaseDate,
                        posterPath: movieCredit.posterPath,
                        backdropPath: movieCredit.backdropPath,
                        popularity: movieCredit.popularity,
                        voteAverage: movieCredit.voteAverage,
                        voteCount: movieCredit.voteCount,
                        hasVideo: movieCredit.hasVideo,
                        isAdultOnly: movieCredit.isAdultOnly
                    )
                )
            case .tvSeries(let tvCredit):
                return .tvSeries(
                    TVSeriesListItem(
                        id: tvCredit.id,
                        name: tvCredit.name,
                        originalName: tvCredit.originalName,
                        originalLanguage: tvCredit.originalLanguage,
                        overview: tvCredit.overview,
                        genreIDs: tvCredit.genreIDs,
                        firstAirDate: tvCredit.firstAirDate,
                        originCountries: tvCredit.originCountries,
                        posterPath: tvCredit.posterPath,
                        backdropPath: tvCredit.backdropPath,
                        popularity: tvCredit.popularity,
                        voteAverage: tvCredit.voteAverage,
                        voteCount: tvCredit.voteCount,
                        isAdultOnly: tvCredit.isAdultOnly
                    )
                )
            }
        }

        return (castShows + crewShows).uniqued()
    }

    /// Creates a person combined credits object.
    ///
    /// - Parameters:
    ///    - id: Person identifier.
    ///    - cast: Shows where person is in the cast.
    ///    - crew: Shows where person is in the crew.
    ///
    public init(id: Int, cast: [ShowCastCredit], crew: [ShowCrewCredit]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
