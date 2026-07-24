//
//  RuntimeMinutesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite("RuntimeMinutes", .tags(.formatting))
struct RuntimeMinutesTests {

    @Test("duration(fromMinutes:) converts whole minutes to a Duration")
    func durationFromMinutes() {
        #expect(RuntimeMinutes.duration(fromMinutes: 139) == .seconds(139 * 60))
        #expect(RuntimeMinutes.duration(fromMinutes: 0) == .zero)
    }

    @Test("minutes(from:) converts a Duration to whole minutes")
    func minutesFromDuration() {
        #expect(RuntimeMinutes.minutes(from: .seconds(139 * 60)) == 139)
        #expect(RuntimeMinutes.minutes(from: .zero) == 0)
    }

    @Test("minutes(from:) truncates a sub-minute remainder")
    func minutesTruncatesSubMinute() {
        #expect(RuntimeMinutes.minutes(from: .seconds(90)) == 1)
    }

    @Test("round-trips whole minutes")
    func roundTripsWholeMinutes() {
        for minutes in [0, 1, 45, 60, 139, 600] {
            let duration = RuntimeMinutes.duration(fromMinutes: minutes)
            #expect(RuntimeMinutes.minutes(from: duration) == minutes)
        }
    }

}
