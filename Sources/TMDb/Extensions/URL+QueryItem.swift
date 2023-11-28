//
//  URL+QueryItem.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
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

extension URL {

    func appendingPathComponent(_ value: Int) -> Self {
        appendingPathComponent(String(value))
    }

    func appendingQueryItem(name: String, value: CustomStringConvertible) -> Self {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value.description))
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }

}

extension URL {

    private enum QueryItemName {
        static let apiKey = "api_key"
        static let language = "language"
        static let imageLanguage = "include_image_language"
        static let videoLanguage = "include_video_language"
        static let page = "page"
        static let year = "year"
        static let firstAirDateYear = "first_air_date_year"
        static let withPeople = "with_people"
    }

    func appendingAPIKey(_ apiKey: String) -> Self {
        appendingQueryItem(name: QueryItemName.apiKey, value: apiKey)
    }

    func appendingLanguage(_ languageCode: String?) -> Self {
        guard let languageCode else {
            return self
        }

        return appendingQueryItem(name: QueryItemName.language, value: languageCode)
    }

    func appendingImageLanguage(_ languageCode: String?) -> Self {
        guard let languageCode else {
            return self
        }

        let value = [languageCode, "null"]
            .map(\.description)
            .joined(separator: ",")

        return appendingQueryItem(name: QueryItemName.imageLanguage, value: value)
    }

    func appendingVideoLanguage(_ languageCode: String?) -> Self {
        guard let languageCode else {
            return self
        }

        let value = [languageCode, "null"]
            .map(\.description)
            .joined(separator: ",")

        return appendingQueryItem(name: QueryItemName.videoLanguage, value: value)
    }

    func appendingPage(_ page: Int?) -> Self {
        guard var page else {
            return self
        }

        page = max(page, 1)
        page = min(page, 1000)

        return appendingQueryItem(name: QueryItemName.page, value: page)
    }

    func appendingYear(_ year: Int?) -> Self {
        guard let year else {
            return self
        }

        return appendingQueryItem(name: QueryItemName.year, value: year)
    }

    func appendingFirstAirDateYear(_ year: Int?) -> Self {
        guard let year else {
            return self
        }

        return appendingQueryItem(name: QueryItemName.firstAirDateYear, value: year)
    }

    func appendingWithPeople(_ peopleIDs: [Person.ID]?) -> Self {
        guard let peopleIDs else {
            return self
        }

        let value = peopleIDs
            .map(\.description)
            .joined(separator: ",")

        return appendingQueryItem(name: QueryItemName.withPeople, value: value)
    }

}
