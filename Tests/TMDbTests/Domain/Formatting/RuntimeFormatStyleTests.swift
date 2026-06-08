//
//  RuntimeFormatStyleTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite("RuntimeFormatStyle", .tags(.formatting))
struct RuntimeFormatStyleTests {

    private let locale = Locale(identifier: "en_US_POSIX")

    @Suite("abbreviated style, hour-minute display")
    struct AbbreviatedHourMinute {

        private let style = RuntimeFormatStyle(
            style: .abbreviated,
            displayUnit: .hourMinute,
            locale: Locale(identifier: "en_US_POSIX")
        )

        @Test("more than one hour")
        func formatsHoursAndMinutes() {
            #expect(style.format(135) == "2h 15m")
        }

        @Test("exact hours omits minutes")
        func formatsExactHours() {
            #expect(style.format(120) == "2h")
        }

        @Test("less than one hour omits hours")
        func formatsMinutesOnly() {
            #expect(style.format(45) == "45m")
        }

        @Test("single hour and minute")
        func formatsSingleHourAndMinute() {
            #expect(style.format(61) == "1h 1m")
        }

        @Test("zero minutes")
        func formatsZero() {
            #expect(style.format(0) == "0m")
        }

        @Test("exact single hour omits minutes")
        func formatsSingleHour() {
            #expect(style.format(60) == "1h")
        }

        @Test("large value")
        func formatsLargeValue() {
            #expect(style.format(605) == "10h 5m")
        }

        @Test("negative input is treated as zero")
        func formatsNegativeAsZero() {
            #expect(style.format(-10) == "0m")
        }
    }

    @Suite("abbreviated style, minutes-only display")
    struct AbbreviatedMinutesOnly {

        private let style = RuntimeFormatStyle(
            style: .abbreviated,
            displayUnit: .minutesOnly,
            locale: Locale(identifier: "en_US_POSIX")
        )

        @Test("renders total minutes")
        func formatsTotalMinutes() {
            #expect(style.format(139) == "139 min")
        }

        @Test("under an hour")
        func formatsUnderAnHour() {
            #expect(style.format(45) == "45 min")
        }

        @Test("zero minutes")
        func formatsZero() {
            #expect(style.format(0) == "0 min")
        }
    }

    @Suite("full style, hour-minute display")
    struct FullHourMinute {

        private let style = RuntimeFormatStyle(
            style: .full,
            displayUnit: .hourMinute,
            locale: Locale(identifier: "en_US_POSIX")
        )

        @Test("more than one hour")
        func formatsHoursAndMinutes() {
            #expect(style.format(135) == "2 hours, 15 minutes")
        }

        @Test("singular hour and minute")
        func formatsSingular() {
            #expect(style.format(61) == "1 hour, 1 minute")
        }

        @Test("exact single hour uses singular hour and omits minutes")
        func formatsSingleHour() {
            #expect(style.format(60) == "1 hour")
        }

        @Test("exact hours omits minutes")
        func formatsExactHours() {
            #expect(style.format(120) == "2 hours")
        }

        @Test("less than one hour omits hours")
        func formatsMinutesOnly() {
            #expect(style.format(45) == "45 minutes")
        }

        @Test("zero minutes")
        func formatsZero() {
            #expect(style.format(0) == "0 minutes")
        }
    }

    @Suite("full style, minutes-only display")
    struct FullMinutesOnly {

        private let style = RuntimeFormatStyle(
            style: .full,
            displayUnit: .minutesOnly,
            locale: Locale(identifier: "en_US_POSIX")
        )

        @Test("renders total minutes")
        func formatsTotalMinutes() {
            #expect(style.format(139) == "139 minutes")
        }

        @Test("singular minute")
        func formatsSingularMinute() {
            #expect(style.format(1) == "1 minute")
        }

        @Test("zero minutes")
        func formatsZero() {
            #expect(style.format(0) == "0 minutes")
        }
    }

    @Test("default initialiser uses abbreviated hour-minute")
    func defaultInitialiser() {
        let style = RuntimeFormatStyle(locale: locale)
        #expect(style.format(135) == "2h 15m")
    }

    @Test("defaulted runtimeStyle accessor uses abbreviated hour-minute")
    func defaultedRuntimeStyleAccessor() {
        let result = 135.formatted(.runtimeStyle().locale(locale))
        #expect(result == "2h 15m")
    }

    @Test("Int convenience formatted accessor")
    func intConvenience() {
        let runtime = 139
        let result = runtime.formatted(.runtimeStyle(.abbreviated, displayUnit: .minutesOnly)
            .locale(locale))
        #expect(result == "139 min")
    }

    @Test("locale modifier returns a copy with the new locale")
    func localeModifier() {
        let style = RuntimeFormatStyle(style: .abbreviated, displayUnit: .hourMinute)
            .locale(locale)
        #expect(style.format(135) == "2h 15m")
    }

    @Test("conforms to Codable")
    func codableRoundTrip() throws {
        let style = RuntimeFormatStyle(style: .full, displayUnit: .hourMinute, locale: locale)
        let data = try JSONEncoder().encode(style)
        let decoded = try JSONDecoder().decode(RuntimeFormatStyle.self, from: data)
        #expect(decoded == style)
    }

    @Test("equal styles are equal and hashable")
    func equatableAndHashable() {
        let lhs = RuntimeFormatStyle(style: .full, displayUnit: .minutesOnly, locale: locale)
        let rhs = RuntimeFormatStyle(style: .full, displayUnit: .minutesOnly, locale: locale)
        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
    }
}
