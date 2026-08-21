//
//  DateFormatter+TMDb.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension DateFormatter {

    /// Day-precision date formatting (e.g. "2025-04-30") at **GMT**.
    ///
    /// This is the outbound half of the day-precision contract, and it must
    /// agree with `JSONDecoder.theMovieDatabaseDateStrategy`. It formats query
    /// parameters for the `discover` and `changes` endpoints, so an unpinned
    /// zone sent the *wrong calendar day* to TMDb for any caller west of
    /// Greenwich — `2024-01-01T00:00:00Z` went out as `2023-12-31` at UTC-8.
    package static var theMovieDatabase: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .gmt
        return dateFormatter
    }

    static var theMovieDatabaseAuth: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss' UTC'"
        dateFormatter.timeZone = .gmt
        return dateFormatter
    }

}
