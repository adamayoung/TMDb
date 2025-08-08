//
//  TVSeriesSearchFilter.swift
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
/// A search filter when searching for TV series.
///
public struct TVSeriesSearchFilter {

    ///
    /// Filter by first air date year.
    ///
    public let firstAirDateYear: Int?

    ///
    /// Filter by the first air date and all episode air dates.
    ///
    public let year: Int?

    ///
    /// Include adult results.
    ///
    public let includeAdult: Bool?

    ///
    /// Creates a search filter for TV series searches.
    ///
    /// - Parameters:
    ///   - firstAirDateYear: Filter by first air date year.
    ///   - year: Filter by the first air date and all episode air dates.
    ///   - includeAdult: Include adult results.
    public init(firstAirDateYear: Int?, year: Int?, includeAdult: Bool?) {
        self.firstAirDateYear = firstAirDateYear
        self.year = year
        self.includeAdult = includeAdult
    }

}
