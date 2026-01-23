//
//  TVSeriesAggregateCredits.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TV series aggregated credits.
///
/// A person can be both a cast member and crew member of the same show.
///
public struct TVSeriesAggregateCredits: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// TV series identifier.
    ///
    public let id: TVSeries.ID

    ///
    /// Cast members of the TV series.
    ///
    public let cast: [AggregateCastMember]

    ///
    /// Crew members of the TV series.
    ///
    public let crew: [AggregateCrewMember]

    ///
    /// Creates a TV series aggregate credits object.
    ///
    /// - Parameters:
    ///    - id: TV series identifier.
    ///    - cast: Cast members of the TV series.
    ///    - crew: Crew members of the TV series.
    ///
    public init(id: TVSeries.ID, cast: [AggregateCastMember], crew: [AggregateCrewMember]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
