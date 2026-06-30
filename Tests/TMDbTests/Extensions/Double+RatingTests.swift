//
//  Double+RatingTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

struct DoubleRatingTests {

    @Test("valid ratings pass", arguments: [0.5, 1.0, 5.5, 8.5, 10.0])
    func validRatingsPass(_ rating: Double) throws {
        try rating.validateAsRating()
    }

    @Test("ratings below 0.5 throw invalidRating", arguments: [0.0, 0.4, -1.0])
    func tooLowRatingsThrow(_ rating: Double) {
        #expect(throws: TMDbError.invalidRating) {
            try rating.validateAsRating()
        }
    }

    @Test("ratings above 10.0 throw invalidRating", arguments: [10.5, 11.0, 100.0])
    func tooHighRatingsThrow(_ rating: Double) {
        #expect(throws: TMDbError.invalidRating) {
            try rating.validateAsRating()
        }
    }

    @Test("ratings not a multiple of 0.5 throw invalidRating", arguments: [0.7, 5.3, 8.25])
    func offStepRatingsThrow(_ rating: Double) {
        #expect(throws: TMDbError.invalidRating) {
            try rating.validateAsRating()
        }
    }

}
