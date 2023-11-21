//
//  JSONDecoder+DecodeFromFile.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

extension JSONDecoder {

    func decode<T>(_: T.Type, fromResource fileName: String,
                   withExtension fileType: String = "json") throws -> T where T: Decodable
    {
        let data = try Data(fromResource: fileName, withExtension: fileType)
        return try decode(T.self, from: data)
    }

}
