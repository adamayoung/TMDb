//
//  JSONDecoder+TMDb.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension JSONDecoder {

    /// Day-precision date parsing (e.g. "2025-04-30") matching the previous
    /// `DateFormatter` configuration: POSIX locale and the current (system) time
    /// zone, since the formatter did not set an explicit time zone.
    private static let theMovieDatabaseDateStrategy = Date.ParseStrategy(
        format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)",
        locale: Locale(identifier: "en_US_POSIX"),
        timeZone: .autoupdatingCurrent
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
    /// reuses the v3 day-precision strategy — including its time zone — so the
    /// same `release_date` decodes to the same instant whichever API version
    /// fetched it.
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
