//
//  SearchEndpoint.swift
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

enum SearchEndpoint {

    case multi(query: String, page: Int? = nil)
    case movies(query: String, year: Int? = nil, page: Int? = nil)
    case tvSeries(query: String, firstAirDateYear: Int? = nil, page: Int? = nil)
    case people(query: String, page: Int? = nil)

}

extension SearchEndpoint: Endpoint {

    static let basePath = URL(string: "/search")!

    private enum QueryItemName {
        static let query = "query"
    }

    var path: URL {
        switch self {
        case let .multi(query, page):
            Self.basePath
                .appendingPathComponent("multi")
                .appendingQueryItem(name: QueryItemName.query, value: query)
                .appendingPage(page)

        case let .movies(query, year, page):
            Self.basePath
                .appendingPathComponent("movie")
                .appendingQueryItem(name: QueryItemName.query, value: query)
                .appendingYear(year)
                .appendingPage(page)

        case let .tvSeries(query, firstAirDateYear, page):
            Self.basePath
                .appendingPathComponent("tv")
                .appendingQueryItem(name: QueryItemName.query, value: query)
                .appendingFirstAirDateYear(firstAirDateYear)
                .appendingPage(page)

        case let .people(query, page):
            Self.basePath
                .appendingPathComponent("person")
                .appendingQueryItem(name: QueryItemName.query, value: query)
                .appendingPage(page)
        }
    }

}
