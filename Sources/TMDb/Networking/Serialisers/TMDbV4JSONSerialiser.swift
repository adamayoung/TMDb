//
//  TMDbV4JSONSerialiser.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The serialiser for the v4 API.
///
/// It exists for one reason: a single v4 response can carry both TMDb date
/// shapes — account-list summaries use `"2026-08-06 23:26:00 UTC"` while list
/// items use `"1999-10-15"` — and neither v3 decoder parses both.
///
/// Encoding reuses the v3 encoder: no v4 request body carries a date.
///
final class TMDbV4JSONSerialiser: Serialiser {

    let mimeType = "application/json"

    init() {}

    func decode<T: Decodable>(_ type: T.Type, from data: Data) async throws -> T {
        let decoder = JSONDecoder.theMovieDatabaseV4

        return try decoder.decode(type, from: data)
    }

    func encode(_ value: some Encodable) async throws -> Data {
        let encoder = JSONEncoder.theMovieDatabase

        return try encoder.encode(value)
    }

}
