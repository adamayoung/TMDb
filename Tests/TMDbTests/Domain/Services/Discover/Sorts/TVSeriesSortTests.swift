//
//  TVSeriesSortTests.swift
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
import Testing

@testable import TMDb

@Suite(.tags(.discover))
struct TVSeriesSortTests {

    @Test("popularity ascending description is popularity.asc")
    func popularityAscendingReturnsRawValue() {
        let sort = TVSeriesSort.popularity(descending: false)

        #expect(sort.description == "popularity.asc")
    }

    @Test("popularity descending description is popularity.desc")
    func popularityDescendingReturnsRawValue() {
        let sort = TVSeriesSort.popularity(descending: true)

        #expect(sort.description == "popularity.desc")
    }

    @Test("firstAirDate ascending description is first_air_date.asc")
    func firstAirDateAscendingReturnsRawValue() {
        let sort = TVSeriesSort.firstAirDate(descending: false)

        #expect(sort.description == "first_air_date.asc")
    }

    @Test("firstAirDate descending description is first_air_date.desc")
    func firstAirDateDescendingReturnsRawValue() {
        let sort = TVSeriesSort.firstAirDate(descending: true)

        #expect(sort.description == "first_air_date.desc")
    }

    @Test("voteAverage ascending description is vote_average.asc")
    func voteAverageAscendingReturnsRawValue() {
        let sort = TVSeriesSort.voteAverage(descending: false)

        #expect(sort.description == "vote_average.asc")
    }

    @Test("voteAverage descending description is vote_average.desc")
    func voteAverageDescendingReturnsRawValue() {
        let sort = TVSeriesSort.voteAverage(descending: true)

        #expect(sort.description == "vote_average.desc")
    }

}
