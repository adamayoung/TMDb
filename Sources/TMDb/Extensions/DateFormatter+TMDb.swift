//
//  DateFormatter+TMDb.swift
//  TMDb
//
//  Created by Adam Young on 20/07/2020.
//

import Foundation

extension DateFormatter {

    static var theMovieDatabase: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddd"
        return dateFormatter
    }

}
