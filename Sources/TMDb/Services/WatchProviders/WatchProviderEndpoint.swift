//
//  WatchProviderEndpoint.swift
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

enum WatchProviderEndpoint {

    case regions
    case movie(regionCode: String?)
    case tvSeries(regionCode: String?)

}

extension WatchProviderEndpoint: Endpoint {

    private static let basePath = URL(string: "/watch/providers")!

    var path: URL {
        switch self {
        case .regions:
            Self.basePath
                .appendingPathComponent("regions")

        case let .movie(regionCode):
            Self.basePath
                .appendingPathComponent("movie")
                .appendingWatchRegion(regionCode)

        case let .tvSeries(regionCode):
            Self.basePath
                .appendingPathComponent("tv")
                .appendingWatchRegion(regionCode)
        }
    }

}

private extension URL {

    private enum QueryItemName {
        static let watchRegion = "watch_region"
    }

    func appendingWatchRegion(_ regionCode: String?) -> URL {
        guard let regionCode else {
            return self
        }

        return appendingQueryItem(name: QueryItemName.watchRegion, value: regionCode)
    }

}
