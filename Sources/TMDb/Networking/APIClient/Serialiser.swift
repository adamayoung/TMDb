//
//  Serialiser.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

actor Serialiser {

    private let decoder: JSONDecoder

    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }

    func decode<T: Decodable>(_ type: T.Type, from data: Data) async throws -> T {
        try decoder.decode(type, from: data)
    }

}
