//
//  Serialiser.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

protocol Serialiser: Sendable {

    var mimeType: String { get }

    func decode<T: Decodable>(_ type: T.Type, from data: Data) async throws -> T

    func encode(_ value: some Encodable) async throws -> Data

}
