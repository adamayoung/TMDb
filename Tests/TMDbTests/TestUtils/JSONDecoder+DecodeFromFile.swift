//
//  JSONDecoder+DecodeFromFile.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
