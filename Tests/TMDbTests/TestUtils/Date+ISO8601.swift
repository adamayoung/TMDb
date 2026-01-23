//
//  Date+ISO8601.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension Date {

    init(iso8601 dateString: String) {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else {
            fatalError("Invalid ISO8601 date string: \(dateString)")
        }

        self = date
    }

}
