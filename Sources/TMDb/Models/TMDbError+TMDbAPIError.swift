//
//  TMDbError+TMDbAPIError.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

extension TMDbError {

    init(error: Error) {
        guard let apiError = error as? TMDbAPIError else {
            self = .unknown
            return
        }

        switch apiError {
        case .notFound:
            self = .notFound

        case let .network(error):
            self = .network(error)

        default:
            self = .unknown
        }
    }

}
