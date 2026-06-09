//
//  UnmappedAPIClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// An API client that performs requests without mapping transport errors into
/// the public ``TMDbError``.
///
/// `TMDbAPIClient` conforms to this protocol and throws the internal
/// ``TMDbAPIError``. ``ErrorMappingAPIClient`` wraps an `UnmappedAPIClient` and
/// translates its errors into `TMDbError`, which is what services depend on.
///
protocol UnmappedAPIClient: Sendable {

    func perform<Request: APIRequest>(_ request: Request) async throws -> Request.Response

}
