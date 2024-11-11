//
//  DiscoverMoviesRequest.swift
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

final class DiscoverMoviesRequest: DecodableAPIRequest<MoviePageableList> {

    init(
        people: [Person.ID]? = nil,
        sortedBy: MovieSort? = nil,
        page: Int? = nil,
        language: String? = nil
    ) {
        let path = "/discover/movie"
        let queryItems = APIRequestQueryItems(
            people: people,
            sortedBy: sortedBy,
            page: page,
            language: language
        )

        super.init(path: path, queryItems: queryItems)
    }

}

extension APIRequestQueryItems {

    fileprivate init(
        people: [Person.ID]?,
        sortedBy: MovieSort?,
        page: Int?,
        language: String?
    ) {
        self.init()

        if let people {
            self[.withPeople] = Self.peopleQueryItemValue(for: people)
        }

        if let sortedBy {
            self[.sortBy] = sortedBy
        }

        if let page {
            self[.page] = page
        }

        if let language {
            self[.language] = language
        }
    }

    private static func peopleQueryItemValue(for people: [Person.ID]) -> String {
        people
            .map(\.description)
            .joined(separator: ",")
    }

}
