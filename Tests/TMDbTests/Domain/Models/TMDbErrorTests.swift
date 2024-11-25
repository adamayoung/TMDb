//
//  TikTokLinkTests.swift
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
struct TMDbErrorTests {

    @Test("not found errors equal")
    func notFoundErrorsEqual() {
        let lhs = TMDbError.notFound
        let rhs = TMDbError.notFound

        #expect(lhs == rhs)
    }

    @Test("unauthorised errors with same message equal")
    func unauthorisedErrorsWithSameMessageEqual() {
        let lhs = TMDbError.unauthorised("Message 1")
        let rhs = TMDbError.unauthorised("Message 1")

        #expect(lhs == rhs)
    }

    @Test("unauthorised errors with different messages do not equal")
    func unauthorisedErrorsWithDifferentMessagesDoNotEqual() {
        let lhs = TMDbError.unauthorised("Message 1")
        let rhs = TMDbError.unauthorised("Message 2")

        #expect(lhs != rhs)
    }

    @Test("network errors equal")
    func networkErrorsEqual() {
        let lhs = TMDbError.network(MockError.test)
        let rhs = TMDbError.network(MockError.test)

        #expect(lhs == rhs)
    }

    @Test("unknown errors equal")
    func unknownErrorsEqual() {
        let lhs = TMDbError.unknown
        let rhs = TMDbError.unknown

        #expect(lhs == rhs)
    }

    @Test("not found and unknown errors do not equal")
    func notFoundAndUnknowErrorsDoNotEqual() {
        let lhs = TMDbError.notFound
        let rhs = TMDbError.unknown

        #expect(lhs != rhs)
    }

    @Test("not found error description is correct")
    func notFoundErrorDescriptionIsCorrect() {
        let description = TMDbError.notFound.errorDescription

        #expect(description == "Not found")
    }

    @Test("unauthorised error description is correct")
    func unauthorisedErrorDescriptionIsCorrect() {
        let description = TMDbError.unauthorised().errorDescription

        #expect(description == "Unauthorised")
    }

    @Test("network error description is correct")
    func networkErrorDescriptionIsCorrect() {
        let description = TMDbError.network(MockError.test).errorDescription

        #expect(description == "Network error")
    }

    @Test("unknown error description is correct")
    func unknownErrorDescriptionIsCorrect() {
        let description = TMDbError.unknown.errorDescription

        #expect(description == "Unknown")
    }

}

extension TMDbErrorTests {

    fileprivate enum MockError: Error {
        case test
        case test2
    }

}
