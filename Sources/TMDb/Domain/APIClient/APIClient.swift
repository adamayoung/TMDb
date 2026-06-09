//
//  APIClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

protocol APIClient: Sendable {

    func perform<Request: APIRequest>(
        _ request: Request
    ) async throws(TMDbError) -> Request.Response

}
