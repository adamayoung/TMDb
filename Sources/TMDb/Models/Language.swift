//
//  Language.swift
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

///
/// A model representing a language.
///
public struct Language: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Language code.
    ///
    public var id: String { code }

    ///
    /// The ISO 639-1 language code.
    ///
    public let code: String

    ///
    /// Language name.
    ///
    public let name: String

    ///
    /// English name.
    ///
    public let englishName: String

    ///
    /// Creates a language object.
    ///
    /// - Parameters:
    ///    - languageCode: ISO 639-1 language code.
    ///    - name: Language name.
    ///    - englishName: English name.
    ///
    public init(code: String, name: String, englishName: String) {
        self.code = code
        self.name = name
        self.englishName = englishName
    }

}

extension Language {

    private enum CodingKeys: String, CodingKey {
        case code = "iso6391"
        case name
        case englishName
    }

}
