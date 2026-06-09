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
