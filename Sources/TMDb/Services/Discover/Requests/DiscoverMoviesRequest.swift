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

    init(sortedBy: MovieSort? = nil, people: [Person.ID]? = nil, page: Int? = nil) {
        let path = "/discover/movie"
        let queryItems = APIRequestQueryItems(sortedBy: sortedBy, people: people, page: page)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    private enum QueryItemName {
        static let sortBy = "sort_by"
        static let withPeople = "with_people"
        static let page = "page"
    }

    init(sortedBy: MovieSort?, people: [Person.ID]?, page: Int?) {
        self.init()

        if let sortedBy {
            self[QueryItemName.sortBy] = "\(sortedBy)"
        }

        if let people {
            self[QueryItemName.withPeople] = Self.peopleQueryItemValue(for: people)
        }

        if let page {
            self[QueryItemName.page] = "\(page)"
        }
    }

    private static func peopleQueryItemValue(for people: [Person.ID]) -> String {
        people
            .map(\.description)
            .joined(separator: ",")
    }

}