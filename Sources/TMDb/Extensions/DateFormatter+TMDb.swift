//
//  DateFormatter+TMDb.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

extension DateFormatter {

    static var theMovieDatabase: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }

}
