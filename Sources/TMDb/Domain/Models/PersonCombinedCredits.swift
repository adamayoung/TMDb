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

    ///
    /// How many credits were skipped while decoding because their media type is
    /// one this library does not model, across both ``cast`` and ``crew``.
    ///
    /// Decode telemetry, not data: it exists so tests can assert that credits are
    /// missing for a known reason rather than a regression. It is zero for a
    /// value built in code.
    ///
    package let droppedItemCount: Int

    /// Creates a person combined credits object.
    ///
    /// - Parameters:
    ///    - id: Person identifier.
    ///    - cast: Shows where person is in the cast.
    ///    - crew: Shows where person is in the crew.
    ///
    public init(id: Int, cast: [ShowCastCredit], crew: [ShowCrewCredit]) {
        self.init(id: id, cast: cast, crew: crew, droppedItemCount: 0)
    }

    ///
    /// Creates a person combined credits object carrying a decode drop count.
    ///
    /// - Parameters:
    ///    - id: Person identifier.
    ///    - cast: Shows where person is in the cast.
    ///    - crew: Shows where person is in the crew.
    ///    - droppedItemCount: How many credits were skipped while decoding.
    ///
    package init(
        id: Int,
        cast: [ShowCastCredit],
        crew: [ShowCrewCredit],
        droppedItemCount: Int
    ) {
        self.id = id
        self.cast = cast
        self.crew = crew
        self.droppedItemCount = droppedItemCount
    }

}

extension PersonCombinedCredits {

    private enum CodingKeys: String, CodingKey {
        case id
        case cast
        case crew
    }

    ///
    /// Creates a person combined credits object by decoding from the given decoder.
    ///
    /// A credit whose media type this library does not model is skipped rather
    /// than failing the whole set, and counted internally for tests. Every
    /// other decode failure throws.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: An error if reading from the decoder fails, or if the data is
    ///   corrupted or otherwise invalid.
    ///
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode(Int.self, forKey: .id)
        let cast = try container.decodeSkippingUnknownMediaTypes(
            ShowCastCredit.self, forKey: .cast
        )
        let crew = try container.decodeSkippingUnknownMediaTypes(
            ShowCrewCredit.self, forKey: .crew
        )

        self.init(
            id: id,
            cast: cast.elements,
            crew: crew.elements,
            droppedItemCount: cast.dropped + crew.dropped
        )
    }

}
