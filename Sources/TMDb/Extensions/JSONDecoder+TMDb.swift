//
//  JSONDecoder+TMDb.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension JSONDecoder {

    /// Day-precision date parsing (e.g. "2025-04-30") at **GMT**.
    ///
    /// TMDb sends a bare calendar day with no zone, so the zone is ours to
    /// choose. GMT is the only choice that makes the same wire value the same
    /// instant everywhere; the previous `.autoupdatingCurrent` was inherited
    /// from an older `DateFormatter` that simply never set one, which made a
    /// release date differ by up to 26 hours between a CI runner and a device.
    ///
    /// `DateFormatter.theMovieDatabase` pins the same zone for the outbound
    /// direction — the two must agree or a date does not round-trip.
    ///
    /// Note this strategy is **lenient**: it rolls out-of-range components over
    /// rather than rejecting them, so `"2025-13-45"` parses as 2026-02-14. That
    /// is why `MediaListItem`, which swallows parse failures with `try?`, keeps
    /// its own validating `.iso8601` strategy instead of sharing this one.
    /// Both halves of that asymmetry are measured — the lenient side in
    /// `DayPrecisionDateTests`, the strict side in
    /// `MediaListItemDateToleranceTests` — so if a future Foundation release
    /// tightens this strategy, the test that justifies the divergence fails
    /// rather than the divergence quietly becoming unnecessary.
    private static let theMovieDatabaseDateStrategy = Date.ParseStrategy(
        format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)",
        locale: Locale(identifier: "en_US_POSIX"),
        timeZone: .gmt
    )

    /// Auth date parsing (e.g. "2016-02-08 14:39:36 UTC").
    private static let theMovieDatabaseAuthDateStrategy = Date.ParseStrategy(
        format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) UTC",
        locale: Locale(identifier: "en_US_POSIX"),
        timeZone: .gmt
    )

    static var theMovieDatabase: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            do {
                return try Date(dateString, strategy: theMovieDatabaseDateStrategy)
            } catch {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Date string does not match format yyyy-MM-dd: \(dateString). Underlying error: \(error)"
                )
            }
        }
        return decoder
    }

    /// The v4 API returns **both** date shapes, sometimes in one response:
    /// account-list summaries carry `"2026-08-06 23:26:00 UTC"` while list
    /// items carry `"1999-10-15"`. Neither v3 decoder handles both.
    ///
    /// The timestamp form is tried first because the day-precision strategy
    /// cannot consume a timestamp that has already failed, and the fallback
    /// reuses the v3 day-precision strategy — including its GMT time zone — so
    /// the same `release_date` decodes to the same instant whichever API
    /// version fetched it.
    static var theMovieDatabaseV4: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            if let date = try? Date(dateString, strategy: theMovieDatabaseAuthDateStrategy) {
                return date
            }

            do {
                return try Date(dateString, strategy: theMovieDatabaseDateStrategy)
            } catch {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Date string matches neither yyyy-MM-dd HH:mm:ss UTC nor yyyy-MM-dd: \(dateString). Underlying error: \(error)"
                )
            }
        }
        return decoder
    }

    static var theMovieDatabaseAuth: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            do {
                return try Date(dateString, strategy: theMovieDatabaseAuthDateStrategy)
            } catch {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Date string does not match format yyyy-MM-dd HH:mm:ss UTC: \(dateString). Underlying error: \(error)"
                )
            }
        }
        return decoder
    }

}
