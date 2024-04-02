//
//  LocaleProvider.swift
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

final class LocaleProvider: LocaleProviding {

    var languageCode: String? {
        #if os(Linux) || os(Windows)
            locale.languageCode
        #else
            if #available(macOS 13.0, *) {
                locale.language.languageCode?.identifier
            } else {
                locale.languageCode
            }
        #endif
    }

    var regionCode: String? {
        #if os(Linux) || os(Windows)
            locale.regionCode
        #else
            if #available(macOS 13.0, *) {
                locale.region?.identifier
            } else {
                locale.regionCode
            }
        #endif
    }

    private let locale: Locale

    init(locale: Locale = .current) {
        self.locale = locale
    }

}
