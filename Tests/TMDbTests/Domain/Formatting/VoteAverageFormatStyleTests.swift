//
//  VoteAverageFormatStyleTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite("VoteAverageFormatStyle", .tags(.formatting))
struct VoteAverageFormatStyleTests {

    private let locale = Locale(identifier: "en_US_POSIX")

    @Test("formats a vote average as a rounded percentage")
    func formatsPercentage() {
        let style = VoteAverageFormatStyle(locale: locale)
        #expect(style.format(8.5) == "85%")
    }

    @Test("rounds to the nearest percent")
    func roundsToNearestPercent() {
        let style = VoteAverageFormatStyle(locale: locale)
        #expect(style.format(7.26) == "73%")
        #expect(style.format(7.24) == "72%")
    }

    @Test("clamps the lower bound to zero")
    func clampsLowerBound() {
        let style = VoteAverageFormatStyle(locale: locale)
        #expect(style.format(-1) == "0%")
    }

    @Test("clamps the upper bound to one hundred")
    func clampsUpperBound() {
        let style = VoteAverageFormatStyle(locale: locale)
        #expect(style.format(11) == "100%")
        #expect(style.format(10) == "100%")
    }

    @Test("formats zero")
    func formatsZero() {
        let style = VoteAverageFormatStyle(locale: locale)
        #expect(style.format(0) == "0%")
    }

    @Test("Double convenience formatted accessor")
    func doubleConvenience() {
        let voteAverage = 8.5
        let result = voteAverage.formatted(.voteAveragePercentage.locale(locale))
        #expect(result == "85%")
    }

    @Test("locale modifier returns a copy with the new locale")
    func localeModifier() {
        let style = VoteAverageFormatStyle().locale(locale)
        #expect(style.format(8.5) == "85%")
    }

    @Test("conforms to Codable")
    func codableRoundTrip() throws {
        let style = VoteAverageFormatStyle(locale: locale)
        let data = try JSONEncoder().encode(style)
        let decoded = try JSONDecoder().decode(VoteAverageFormatStyle.self, from: data)
        #expect(decoded == style)
    }

    @Test("equal styles are equal and hashable")
    func equatableAndHashable() {
        let lhs = VoteAverageFormatStyle(locale: locale)
        let rhs = VoteAverageFormatStyle(locale: locale)
        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
    }
}
