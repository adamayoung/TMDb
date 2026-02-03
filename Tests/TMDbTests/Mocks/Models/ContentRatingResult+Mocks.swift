//
//  ContentRatingResult+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

extension ContentRatingResult {

    static var mock: Self {
        .init(
            results: .mocks,
            id: 8592
        )
    }

}
