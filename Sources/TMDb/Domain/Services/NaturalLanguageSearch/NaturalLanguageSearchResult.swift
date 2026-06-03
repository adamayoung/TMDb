//
//  NaturalLanguageSearchResult.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The outcome of a natural-language search.
///
/// A result groups matching entities by type. Depending on the prompt, one or
/// more of the entity collections may be empty.
///
public struct NaturalLanguageSearchResult: Sendable, Equatable {

    ///
    /// A restatement of how the prompt was interpreted, suitable for display.
    ///
    public let interpretation: String?

    ///
    /// Matching movies.
    ///
    public let movies: [MovieListItem]

    ///
    /// Matching TV series.
    ///
    public let tvSeries: [TVSeriesListItem]

    ///
    /// Matching people.
    ///
    public let people: [PersonListItem]

    ///
    /// Ways in which the results are partial or approximate.
    ///
    public let degradations: [SearchDegradation]

    ///
    /// Creates a natural-language search result.
    ///
    /// - Parameters:
    ///   - interpretation: A restatement of how the prompt was interpreted.
    ///   - movies: Matching movies.
    ///   - tvSeries: Matching TV series.
    ///   - people: Matching people.
    ///   - degradations: Ways in which the results are partial or approximate.
    ///
    public init(
        interpretation: String? = nil,
        movies: [MovieListItem] = [],
        tvSeries: [TVSeriesListItem] = [],
        people: [PersonListItem] = [],
        degradations: [SearchDegradation] = []
    ) {
        self.interpretation = interpretation
        self.movies = movies
        self.tvSeries = tvSeries
        self.people = people
        self.degradations = degradations
    }

}
