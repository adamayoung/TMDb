//
//  CompanyAlternativeNamesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CompanyAlternativeNamesRequest: DecodableAPIRequest<CompanyAlternativeNameCollection> {

    init(id: Company.ID) {
        let path = "/company/\(id)/alternative_names"

        super.init(path: path)
    }

}
