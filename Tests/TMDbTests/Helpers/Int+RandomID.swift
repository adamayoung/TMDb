//
//  Int+RandomID.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

extension Int {

    static var randomID: Self {
        .random(in: 1 ... 10_000_000)
    }

}
