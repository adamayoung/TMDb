//
//  ValidateKeyRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class ValidateKeyRequest: DecodableAPIRequest<SuccessResult> {

    init() {
        let path = "/authentication"

        super.init(path: path)
    }

}
