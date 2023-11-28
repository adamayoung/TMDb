//
//  TrendingEndpoint.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the License );
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

enum TrendingEndpoint {

    case movies(timeWindow: TrendingTimeWindowFilterType = .day, page: Int? = nil)
    case tvSeries(timeWindow: TrendingTimeWindowFilterType = .day, page: Int? = nil)
    case people(timeWindow: TrendingTimeWindowFilterType = .day, page: Int? = nil)

}

extension TrendingEndpoint: Endpoint {

    private static let basePath = URL(string: "/trending")!

    var path: URL {
        switch self {
        case let .movies(timeWindow, page):
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingPathComponent(timeWindow)
                .appendingPage(page)

        case let .tvSeries(timeWindow, page):
            return Self.basePath
                .appendingPathComponent("tv")
                .appendingPathComponent(timeWindow)
                .appendingPage(page)

        case let .people(timeWindow, page):
            return Self.basePath
                .appendingPathComponent("person")
                .appendingPathComponent(timeWindow)
                .appendingPage(page)
        }
    }

}
