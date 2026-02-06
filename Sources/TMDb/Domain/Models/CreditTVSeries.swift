//
//  CreditTVSeries.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TV series in a credit response.
///
public struct CreditTVSeries: Identifiable, Codable, Equatable,
Hashable, Sendable {

    ///
    /// TV series identifier.
    ///
    public let id: Int

    ///
    /// TV series name.
    ///
    public let name: String?

    ///
    /// TV series original name.
    ///
    public let originalName: String?

    ///
    /// TV series overview.
    ///
    public let overview: String?

    ///
    /// TV series poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// TV series backdrop path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let backdropPath: URL?

    ///
    /// TV series popularity.
    ///
    public let popularity: Double?

    ///
    /// TV series first air date.
    ///
    public let firstAirDate: Date?

    ///
    /// Average vote score.
    ///
    public let voteAverage: Double?

    ///
    /// Number of votes.
    ///
    public let voteCount: Int?

    ///
    /// Character played in the TV series.
    ///
    public let character: String?

    ///
    /// Creates a credit TV series object.
    ///
    /// - Parameters:
    ///    - id: TV series identifier.
    ///    - name: TV series name.
    ///    - originalName: TV series original name.
    ///    - overview: TV series overview.
    ///    - posterPath: TV series poster path.
    ///    - backdropPath: TV series backdrop path.
    ///    - popularity: TV series popularity.
    ///    - firstAirDate: TV series first air date.
    ///    - voteAverage: Average vote score.
    ///    - voteCount: Number of votes.
    ///    - character: Character played.
    ///
    public init(
        id: Int,
        name: String? = nil,
        originalName: String? = nil,
        overview: String? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        popularity: Double? = nil,
        firstAirDate: Date? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        character: String? = nil
    ) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.popularity = popularity
        self.firstAirDate = firstAirDate
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.character = character
    }

}
