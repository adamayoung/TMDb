//
//  ClearV4ListRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Removes every item from a list.
///
/// - Note: This is a **`GET`** that changes state — `POST` to the same path
///   returns 404. `CacheHTTPClient` recognises a `GET` whose path ends `/clear`
///   and routes it through its mutation path, so it invalidates the cache
///   rather than populating it.
///
final class ClearV4ListRequest: DecodableAPIRequest<V4ClearListResult> {

    init(listID: Int, accessToken: String) {
        super.init(
            path: "/list/\(listID)/clear",
            headers: .v4Authorization(accessToken)
        )
    }

}
