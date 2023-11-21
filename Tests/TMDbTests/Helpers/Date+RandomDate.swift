//
//  Date+RandomDate.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

extension Date {

    static var random: Self {
        let date = Date().timeIntervalSince1970
        let timeInterval = Double.random(in: 1_118_839_159 ... date)
        return Date(timeIntervalSince1970: timeInterval)
    }

}
