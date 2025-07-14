//
//  TVSeriesAggregateCredits.swift
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
    public let cast: [AggregrateCastMember]

    ///
    /// Crew members of the TV series.
    ///
    public let crew: [AggregrateCrewMember]

    ///
    /// Creates a TV series aggregrate credits object.
    ///
    /// - Parameters:
    ///    - id: TV series identifier.
    ///    - cast: Cast members of the TV series.
    ///    - crew: Crew members of the TV series.
    ///
    public init(id: TVSeries.ID, cast: [AggregrateCastMember], crew: [AggregrateCrewMember]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
