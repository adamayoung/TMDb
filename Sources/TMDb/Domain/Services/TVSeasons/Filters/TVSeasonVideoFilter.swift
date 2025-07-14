//
//  TVSeasonVideoFilter.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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
/// A filter for fetching TV season videos.
///
public struct TVSeasonVideoFilter {

    ///
    /// A list of ISO 639-1 language codes to filter videos by.
    ///
    public let languages: [String]?

    ///
    /// Creates a TV season video filter.
    ///
    /// - Parameter languages: A list of ISO 639-1 language codes to filter videos by.
    ///
    public init(languages: [String]? = nil) {
        self.languages = languages
    }

}
