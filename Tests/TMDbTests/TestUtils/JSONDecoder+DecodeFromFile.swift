//
//  JSONDecoder+DecodeFromFile.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

extension JSONDecoder {

    func decode<T>(
        _: T.Type,
        fromResource fileName: String,
        withExtension fileType: String = "json",
        file _: StaticString = #filePath,
        line _: UInt = #line
    ) throws -> T where T: Decodable {
        do {
            let data = try Data(fromResource: fileName, withExtension: fileType)
            return try decode(T.self, from: data)
        } catch let error {
            Issue.record(error, "Decode error")
            throw error
        }
    }

}
