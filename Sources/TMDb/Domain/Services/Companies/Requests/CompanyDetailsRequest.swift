//
//  CompanyDetailsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CompanyDetailsRequest: DecodableAPIRequest<Company> {

    init(id: Company.ID) {
        let path = "/company/\(id)"

        super.init(path: path)
    }

}
