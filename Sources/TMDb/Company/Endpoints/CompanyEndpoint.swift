//
//  CompanyEndpoint.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

enum CompanyEndpoint {

    case details(companyID: Company.ID)

}

extension CompanyEndpoint: Endpoint {

    private static let basePath = URL(string: "/company")!

    var path: URL {
        switch self {
        case let .details(companyID):
            return Self.basePath
                .appendingPathComponent(companyID)
        }
    }

}
