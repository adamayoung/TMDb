//
//  MoviesEndpoint.swift
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

enum MoviesEndpoint {

    case details(movieID: Movie.ID)
    case credits(movieID: Movie.ID)
    case reviews(movieID: Movie.ID, page: Int? = nil)
    case images(movieID: Movie.ID, languageCode: String?)
    case videos(movieID: Movie.ID, languageCode: String?)
    case recommendations(movieID: Movie.ID, page: Int? = nil)
    case similar(movieID: Movie.ID, page: Int? = nil)
    case nowPlaying(page: Int? = nil)
    case popular(page: Int? = nil)
    case topRated(page: Int? = nil)
    case upcoming(page: Int? = nil)
    case watch(movieID: Movie.ID)
    case externalIDs(movieID: Movie.ID)

}

extension MoviesEndpoint: Endpoint {

    private static let basePath = URL(string: "/movie")!

    var path: URL {
        switch self {
        case let .details(movieID):
            Self.basePath
                .appendingPathComponent(movieID)

        case let .credits(movieID):
            Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("credits")

        case let .reviews(movieID, page):
            Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("reviews")
                .appendingPage(page)

        case let .images(movieID, languageCode):
            Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("images")
                .appendingImageLanguage(languageCode)

        case let .videos(movieID, languageCode):
            Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("videos")
                .appendingVideoLanguage(languageCode)

        case let .recommendations(movieID, page):
            Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("recommendations")
                .appendingPage(page)

        case let .similar(movieID, page):
            Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("similar")
                .appendingPage(page)

        case let .nowPlaying(page):
            Self.basePath
                .appendingPathComponent("now_playing")
                .appendingPage(page)

        case let .popular(page):
            Self.basePath
                .appendingPathComponent("popular")
                .appendingPage(page)

        case let .topRated(page):
            Self.basePath
                .appendingPathComponent("top_rated")
                .appendingPage(page)

        case let .upcoming(page):
            Self.basePath
                .appendingPathComponent("upcoming")
                .appendingPage(page)

        case let .watch(movieID):
            Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("watch/providers")

        case let .externalIDs(movieID):
            Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("external_ids")
        }
    }

}
