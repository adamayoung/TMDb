//
//  CreditRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CreditRequest: DecodableAPIRequest<Credit> {

    init(id: Credit.ID) {
        let path = "/credit/\(id.urlPathSegmentEncoded)"

        super.init(path: path)
    }

}
