//
//  CreateListResult+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension CreateListResult {

    /// A sample `CreateListResult` populated with representative data.
    static var sample: CreateListResult {
        CreateListResult(
            success: true,
            statusMessage: "The item/record was created successfully.",
            statusCode: 1,
            listID: 1234
        )
    }

}
