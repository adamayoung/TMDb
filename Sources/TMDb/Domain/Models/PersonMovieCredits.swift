//
//  PersonMovieCredits.swift
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
    public var allShows: [Movie] {
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
