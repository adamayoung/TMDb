//
//  TVSeriesAggregateCreditsTests.swift
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
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVSeriesAggregateCreditsTests {

    @Test("JSON decoding of TVSeriesAggregateCredits", .tags(.decoding))
    func decodeReturnsTVSeriesAggregateCredits() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesAggregateCredits.self,
            fromResource: "tv-series-aggregate-credits"
        )

        #expect(result.id == 4604)
        #expect(result.cast.count == 4)
        #expect(result.crew.count == 2)
    }

}
