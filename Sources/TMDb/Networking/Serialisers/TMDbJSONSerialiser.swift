//
//  TMDbJSONSerialiser.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TMDbJSONSerialiser: Serialiser {

    let mimeType = "application/json"

    init() {}

    func decode<T: Decodable>(_ type: T.Type, from data: Data) async throws -> T {
        let decoder = JSONDecoder.theMovieDatabase

        return try decoder.decode(type, from: data)
    }

    func encode(_ value: some Encodable) async throws -> Data {
        let encoder = JSONEncoder.theMovieDatabase

        return try encoder.encode(value)
    }

}
