//
//  TMDbErrorTMDbAPIErrorTests.swift
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
struct TMDbErrorTMDbAPIErrorTests {

    @Test("init when error is not a TMDbAPIError returns unknown error")
    func initWithNonTMDbAPIErrorReturnsUnknownError() {
        let error = NSError(domain: "test", code: -1)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .unknown)
    }

    @Test("init when error is a TMDbAPIError.notFound returns notFound error")
    func initWithNotFoundTMDbAPIErrorReturnsNotFoundError() {
        let error = TMDbAPIError.notFound(nil)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .notFound)
    }

    @Test("init when error is a TMDbAPIError.unauthorised returns unauthorised error")
    func initWithUnauthorisedTMDbAPIErrorReturnsNotFoundError() {
        let error = TMDbAPIError.unauthorised(nil)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .unauthorised(nil))
    }

}
