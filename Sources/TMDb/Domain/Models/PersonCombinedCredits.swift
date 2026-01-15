//
//  PersonCombinedCredits.swift
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
