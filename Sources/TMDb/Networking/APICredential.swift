//
//  APICredential.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The credential a ``TMDbClient`` uses to authenticate API requests.
///
/// TMDb accepts either a v3 API key (as a query item) or a v4 access token (as
/// an `Authorization: Bearer` header) on its v3 endpoints. This internal type
/// lets the client carry either while the request-building logic stays in one
/// place.
///
enum APICredential: Equatable {

    /// A TMDb v3 API key, sent as the `api_key` query item on every request.
    case apiKey(String)

    /// A TMDb v4 access token, sent as an `Authorization: Bearer` header,
    /// keeping the credential out of the request URL.
    case bearerToken(String)

}
