//
//  APIConfiguration+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension APIConfiguration {

    /// A sample `APIConfiguration` for use in previews and tests.
    static var sample: APIConfiguration {
        APIConfiguration(
            images: .sample,
            changeKeys: ["adult", "air_date", "also_known_as"]
        )
    }

}
