//
//  CompanyImagesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CompanyImagesRequest: DecodableAPIRequest<CompanyImageCollection> {

    init(id: Company.ID) {
        let path = "/company/\(id)/images"

        super.init(path: path)
    }

}
