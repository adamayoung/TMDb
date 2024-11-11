//
//  TVSeriesSearchRequest.swift
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

final class TVSeriesSearchRequest: DecodableAPIRequest<TVSeriesPageableList> {

    init(
        query: String,
        firstAirDateYear: Int? = nil,
        year: Int? = nil,
        includeAdult: Bool? = nil,
        page: Int? = nil,
        language: String? = nil
    ) {
        let path = "/search/tv"
        let queryItems = APIRequestQueryItems(
            query: query,
            firstAirDateYear: firstAirDateYear,
            year: year,
            includeAdult: includeAdult,
            page: page,
            language: language
        )

        super.init(path: path, queryItems: queryItems)
    }

}

extension APIRequestQueryItems {

    fileprivate init(
        query: String,
        firstAirDateYear: Int?,
        year: Int?,
        includeAdult: Bool?,
        page: Int?,
        language: String?
    ) {
        self.init()

        self[.query] = query

        if let firstAirDateYear {
            self[.firstAirDateYear] = firstAirDateYear
        }

        if let year {
            self[.year] = year
        }

        if let includeAdult {
            self[.includeAdult] = includeAdult
        }

        if let page {
            self[.page] = page
        }

        if let language {
            self[.language] = language
        }
    }

}
