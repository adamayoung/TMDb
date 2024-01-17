//
//  PersonTVSeriesCredits.swift
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
/// A model representing a TV series credits for a person.
///
/// A person can be both a cast member and crew member of the same TV series.
///
public struct PersonTVSeriesCredits: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Person identifier.
    ///
    public let id: Int

    ///
    /// TV series where the person is in the cast.
    ///
    public let cast: [TVSeries]

    ///
    /// TV series where the person is in the crew.
    ///
    public let crew: [TVSeries]

    ///
    /// All TV series the person is in.
    ///
    public var allShows: [TVSeries] {
        (cast + crew).uniqued()
    }

    ///
    /// Creates a person TV series credits object.
    ///
    /// - Parameters:
    ///    - id: Person identifier.
    ///    - cast: TV series where the person is in the cast.
    ///    - crew: TV series where the person is in the crew.
    ///
    public init(id: Int, cast: [TVSeries], crew: [TVSeries]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
