//
//  PeopleEndpoint.swift
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

enum PeopleEndpoint {

    case details(personID: Person.ID)
    case combinedCredits(personID: Person.ID)
    case movieCredits(personID: Person.ID)
    case tvSeriesCredits(personID: Person.ID)
    case images(personID: Person.ID)
    case popular(page: Int? = nil)
    case externalIDs(personID: Person.ID)

}

extension PeopleEndpoint: Endpoint {

    private static let basePath = URL(string: "/person")!

    var path: URL {
        switch self {
        case let .details(personID):
            Self.basePath
                .appendingPathComponent(personID)

        case let .combinedCredits(personID):
            Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("combined_credits")

        case let .movieCredits(personID):
            Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("movie_credits")

        case let .tvSeriesCredits(personID):
            Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("tv_credits")

        case let .images(personID):
            Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("images")

        case let .popular(page):
            Self.basePath
                .appendingPathComponent("popular")
                .appendingPage(page)

        case let .externalIDs(personID):
            Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("external_ids")
        }
    }

}
