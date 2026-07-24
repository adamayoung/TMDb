//
//  TMDbErrorContextTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TMDbErrorContextTests {

    @Test("init defaults every field to nil")
    func initDefaultsEveryFieldToNil() {
        let context = TMDbErrorContext()

        #expect(context.httpStatusCode == nil)
        #expect(context.tmdbStatusCode == nil)
        #expect(context.statusMessage == nil)
        #expect(context.endpointPath == nil)
        #expect(context.retryAfter == nil)
    }

    @Test("init assigns every field")
    func initAssignsEveryField() {
        let context = TMDbErrorContext(
            httpStatusCode: 404,
            tmdbStatusCode: .resourceNotFound,
            statusMessage: "The resource you requested could not be found.",
            endpointPath: "/movie/999999999",
            retryAfter: .seconds(5)
        )

        #expect(context.httpStatusCode == 404)
        #expect(context.tmdbStatusCode == .resourceNotFound)
        #expect(context.statusMessage == "The resource you requested could not be found.")
        #expect(context.endpointPath == "/movie/999999999")
        #expect(context.retryAfter == .seconds(5))
    }

    @Test("contexts with equal fields are equal")
    func contextsWithEqualFieldsAreEqual() {
        let lhs = TMDbErrorContext(httpStatusCode: 401, tmdbStatusCode: .invalidAPIKey)
        let rhs = TMDbErrorContext(httpStatusCode: 401, tmdbStatusCode: .invalidAPIKey)

        #expect(lhs == rhs)
    }

    @Test("contexts with different fields are not equal")
    func contextsWithDifferentFieldsAreNotEqual() {
        let lhs = TMDbErrorContext(httpStatusCode: 401)
        let rhs = TMDbErrorContext(httpStatusCode: 404)

        #expect(lhs != rhs)
    }

}
