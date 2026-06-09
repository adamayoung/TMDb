//
//  DateFormatter+TestHelpers.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// Test-only helper: provides a DateFormatter for creating Date values in test fixtures.
/// Production code uses Date.ParseStrategy (decoder) and Date.ISO8601FormatStyle (encoding).
extension DateFormatter {

    static var theMovieDatabase: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }

}
