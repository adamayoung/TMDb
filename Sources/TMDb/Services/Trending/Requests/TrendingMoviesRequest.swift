//
//  TrendingMoviesRequest.swift
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

final class TrendingMoviesRequest: DecodableAPIRequest<MoviePageableList> {

    init(timeWindow: TrendingTimeWindowFilterType, page: Int?) {
        let path = "/trending/movie/\(timeWindow.rawValue)"
        let queryItems = APIRequestQueryItems(page: page)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    private enum QueryItemName {
        static let page = "page"
    }

    init(page: Int?) {
        self.init()

        if let page {
            self[QueryItemName.page] = "\(page)"
        }
    }

}
