//
//  CreateRequestTokenRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CreateRequestTokenRequest: DecodableAPIRequest<Token> {

    init() {
        let path = "/authentication/token/new"

        super.init(path: path)
    }

}
