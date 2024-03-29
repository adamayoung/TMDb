//
//  AccountEndpoint.swift
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

enum AccountEndpoint {

    case details(sessionID: String)
    case favouriteMovies(sortedBy: FavouriteSort? = nil, page: Int? = nil, accountID: Int, sessionID: String)
    case favouriteTVSeries(sortedBy: FavouriteSort? = nil, page: Int? = nil, accountID: Int, sessionID: String)
    case addFavourite(accountID: Int, sessionID: String)
    case movieWatchlist(sortedBy: WatchlistSort? = nil, page: Int? = nil, accountID: Int, sessionID: String)
    case tvSeriesWatchlist(sortedBy: WatchlistSort? = nil, page: Int? = nil, accountID: Int, sessionID: String)
    case addToWatchlist(accountID: Int, sessionID: String)

}

extension AccountEndpoint: Endpoint {

    private static let basePath = URL(string: "/account")!

    private enum QueryItemName {
        static let sessionID = "session_id"
    }

    var path: URL {
        switch self {
        case let .details(sessionID):
            Self.basePath
                .appendingQueryItem(name: QueryItemName.sessionID, value: sessionID)

        case let .favouriteMovies(sortedBy, page, accountID, sessionID):
            Self.basePath
                .appendingPathComponent(accountID)
                .appendingPathComponent("favorite")
                .appendingPathComponent("movies")
                .appendingSortBy(sortedBy)
                .appendingPage(page)
                .appendingQueryItem(name: QueryItemName.sessionID, value: sessionID)

        case let .favouriteTVSeries(sortedBy, page, accountID, sessionID):
            Self.basePath
                .appendingPathComponent(accountID)
                .appendingPathComponent("favorite")
                .appendingPathComponent("tv")
                .appendingSortBy(sortedBy)
                .appendingPage(page)
                .appendingQueryItem(name: QueryItemName.sessionID, value: sessionID)

        case let .addFavourite(accountID, sessionID):
            Self.basePath
                .appendingPathComponent(accountID)
                .appendingPathComponent("favorite")
                .appendingQueryItem(name: QueryItemName.sessionID, value: sessionID)

        case let .movieWatchlist(sortedBy, page, accountID, sessionID):
            Self.basePath
                .appendingPathComponent(accountID)
                .appendingPathComponent("watchlist")
                .appendingPathComponent("movies")
                .appendingSortBy(sortedBy)
                .appendingPage(page)
                .appendingQueryItem(name: QueryItemName.sessionID, value: sessionID)

        case let .tvSeriesWatchlist(sortedBy, page, accountID, sessionID):
            Self.basePath
                .appendingPathComponent(accountID)
                .appendingPathComponent("watchlist")
                .appendingPathComponent("tv")
                .appendingSortBy(sortedBy)
                .appendingPage(page)
                .appendingQueryItem(name: QueryItemName.sessionID, value: sessionID)

        case let .addToWatchlist(accountID, sessionID):
            Self.basePath
                .appendingPathComponent(accountID)
                .appendingPathComponent("watchlist")
                .appendingQueryItem(name: QueryItemName.sessionID, value: sessionID)
        }
    }

}
