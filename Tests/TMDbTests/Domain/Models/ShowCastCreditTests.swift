//
//  ShowCastCreditTests.swift
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
struct ShowCastCreditTests {

    @Test("JSON decoding of ShowCastCredit with movie", .tags(.decoding))
    func decodeReturnsShowCastCreditWithMovie() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ShowCastCredit.self, fromResource: "show-cast-credit-movie")

        guard case .movie(let credit) = result else {
            Issue.record("Expected movie cast credit")
            return
        }

        #expect(credit.id == 109_091)
        #expect(credit.character == "Westray")
    }

    @Test("JSON decoding of ShowCastCredit with TV series", .tags(.decoding))
    func decodeReturnsShowCastCreditWithTVSeries() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ShowCastCredit.self, fromResource: "show-cast-credit-tv")

        guard case .tvSeries(let credit) = result else {
            Issue.record("Expected TV series cast credit")
            return
        }

        #expect(credit.id == 54)
        #expect(credit.character == "")
    }

}
