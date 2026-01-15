//
//  ShowCrewCreditTests.swift
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

@Suite(.tags(.models))
struct ShowCrewCreditTests {

    @Test("JSON decoding of ShowCrewCredit with movie", .tags(.decoding))
    func decodeReturnsShowCrewCreditWithMovie() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ShowCrewCredit.self, fromResource: "show-crew-credit-movie")

        guard case .movie(let credit) = result else {
            Issue.record("Expected movie crew credit")
            return
        }

        #expect(credit.id == 174_349)
        #expect(credit.job == "Executive Producer")
        #expect(credit.department == "Production")
    }

    @Test("JSON decoding of ShowCrewCredit with TV series", .tags(.decoding))
    func decodeReturnsShowCrewCreditWithTVSeries() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ShowCrewCredit.self, fromResource: "show-crew-credit-tv")

        guard case .tvSeries(let credit) = result else {
            Issue.record("Expected TV series crew credit")
            return
        }

        #expect(credit.id == 69_061)
        #expect(credit.job == "Executive Producer")
        #expect(credit.department == "Production")
    }

}
