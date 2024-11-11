//
//  MovieReviewsRequest.swift
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

final class MovieReviewsRequest: DecodableAPIRequest<ReviewPageableList> {

    init(id: Movie.ID, page: Int? = nil, language: String? = nil) {
        let path = "/movie/\(id)/reviews"
        let queryItems = APIRequestQueryItems(page: page, language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

extension APIRequestQueryItems {

    fileprivate init(page: Int?, language: String?) {
        self.init()

        if let page {
            self[.page] = page
        }

        if let language {
            self[.language] = language
        }
    }

}
