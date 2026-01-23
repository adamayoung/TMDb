//
//  APIRequestQueryItem.swift
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

typealias APIRequestQueryItems = [APIRequestQueryItem.Name: CustomStringConvertible]

enum APIRequestQueryItem {

    struct Name: ExpressibleByStringLiteral, CustomStringConvertible, Equatable, Hashable {

        private let name: String

        init(_ name: String) {
            self.name = name
        }

        init(stringLiteral: String) {
            self.init(stringLiteral)
        }

        var description: String {
            name
        }

    }

}

extension APIRequestQueryItem.Name {

    static let page = APIRequestQueryItem.Name("page")
    static let sortBy = APIRequestQueryItem.Name("sort_by")
    static let watchRegion = APIRequestQueryItem.Name("watch_region")
    static let includeImageLanguage = APIRequestQueryItem.Name("include_image_language")
    static let includeVideoLanguage = APIRequestQueryItem.Name("include_video_language")
    static let includeAdult = APIRequestQueryItem.Name("include_adult")
    static let query = APIRequestQueryItem.Name("query")
    static let year = APIRequestQueryItem.Name("year")
    static let primaryReleaseYear = APIRequestQueryItem.Name("primary_release_year")
    static let firstAirDateYear = APIRequestQueryItem.Name("first_air_date_year")
    static let sessionID = APIRequestQueryItem.Name("session_id")
    static let language = APIRequestQueryItem.Name("language")
    static let region = APIRequestQueryItem.Name("region")

    static let withPeople = APIRequestQueryItem.Name("with_people")
    static let withOriginalLanguage = APIRequestQueryItem.Name("with_original_language")
    static let withGenres = APIRequestQueryItem.Name("with_genres")
    static let primaryReleaseDateGreaterThan = APIRequestQueryItem.Name("primary_release_date.gte")
    static let primaryReleaseDateLessThan = APIRequestQueryItem.Name("primary_release_date.lte")

    static let apiKey = APIRequestQueryItem.Name("api_key")

}
