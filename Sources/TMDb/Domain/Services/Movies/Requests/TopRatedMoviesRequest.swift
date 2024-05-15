//
//  TopRatedMoviesRequest.swift
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

final class TopRatedMoviesRequest: DecodableAPIRequest<MoviePageableList> {

    init(page: Int? = nil, country: String? = nil, language: String? = nil) {
        let path = "/movie/top_rated"
        let queryItems = APIRequestQueryItems(page: page, country: country, language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(page: Int?, country: String?, language: String?) {
        self.init()

        if let page {
            self[.page] = page
        }

        if let country {
            self[.region] = country
        }

        if let language {
            self[.language] = language
        }
    }

}
