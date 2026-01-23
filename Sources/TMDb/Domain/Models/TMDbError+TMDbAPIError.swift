//
//  TMDbError+TMDbAPIError.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension TMDbError {

    init(error: some Error) {
        guard let apiError = error as? TMDbAPIError else {
            self = .unknown
            return
        }

        switch apiError {
        case .notFound:
            self = .notFound

        case .unauthorised(let message):
            self = .unauthorised(message)

        case .network(let error):
            self = .network(error)

        default:
            self = .unknown
        }
    }

}
