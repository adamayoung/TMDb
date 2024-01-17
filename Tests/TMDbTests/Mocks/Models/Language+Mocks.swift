//
//  Language+Mocks.swift
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
import TMDb

extension Language {

    static func mock(
        code: String = "en",
        name: String = .randomString,
        englishName: String = .randomString
    ) -> Self {
        .init(
            code: code,
            name: name,
            englishName: englishName
        )
    }

    static var african: Self {
        .mock(code: "af", name: "Afrikaans", englishName: "Afrikaans")
    }

    static var hungarian: Self {
        .mock(code: "hu", name: "Magyar", englishName: "Hungarian")
    }

    static var irish: Self {
        .mock(code: "ga", name: "Gaeilge", englishName: "Irish")
    }

    static var english: Self {
        .mock(code: "en", name: "English", englishName: "English")
    }

}

extension [Language] {

    static var mocks: [Language] {
        [.african, .hungarian, .irish, .english]
    }

}
