//
//  TMDbErrorTMDbAPIErrorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
