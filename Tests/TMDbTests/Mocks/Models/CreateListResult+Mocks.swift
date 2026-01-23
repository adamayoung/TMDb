//
//  CreateListResult+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension CreateListResult {

    static func mock(
        success: Bool = true,
        statusMessage: String = "The item/record was created successfully.",
        statusCode: Int = 1,
        listID: Int = 1234
    ) -> CreateListResult {
        CreateListResult(
            success: success,
            statusMessage: statusMessage,
            statusCode: statusCode,
            listID: listID
        )
    }

}
