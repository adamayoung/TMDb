//
//  DeleteV4ListRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class DeleteV4ListRequest: DecodableAPIRequest<SuccessResult> {

    init(listID: Int, accessToken: String) {
        super.init(
            path: "/list/\(listID)",
            method: .delete,
            headers: .v4Authorization(accessToken)
        )
    }

}
