//
//  ShowCredits.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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
/// A model representing a show's (movie or TV series) credits.
///
/// A person can be both a cast member and crew member of the same show.
///
public struct ShowCredits: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Movie or TV series identifier.
    ///
    public let id: Int

    ///
    /// Cast members of the show.
    ///
    public let cast: [CastMember]

    ///
    /// Crew members of the show.
    ///
    public let crew: [CrewMember]

    ///
    /// Creates a show credits object.
    ///
    /// - Parameters:
    ///    - id: Movie or TV series identifier.
    ///    - cast: Cast members of the show.
    ///    - crew: Crew members of the show.
    ///
    public init(id: Int, cast: [CastMember], crew: [CrewMember]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
