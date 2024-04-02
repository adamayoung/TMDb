//
//  TMDbAuthSerialiser.swift
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

final class TMDbAuthJSONSerialiser: Serialiser {

    init() {}

    func decode<T: Decodable>(_ type: T.Type, from data: Data) async throws -> T {
        let decoder = JSONDecoder.theMovieDatabaseAuth

        return try decoder.decode(type, from: data)
    }

    func encode(_ value: some Encodable) async throws -> Data {
        let encoder = JSONEncoder.theMovieDatabaseAuth

        return try encoder.encode(value)
    }

}
