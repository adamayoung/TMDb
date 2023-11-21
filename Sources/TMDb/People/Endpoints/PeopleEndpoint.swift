//
//  PeopleEndpoint.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

enum PeopleEndpoint {

    case details(personID: Person.ID)
    case combinedCredits(personID: Person.ID)
    case movieCredits(personID: Person.ID)
    case tvSeriesCredits(personID: Person.ID)
    case images(personID: Person.ID)
    case popular(page: Int? = nil)

}

extension PeopleEndpoint: Endpoint {

    private static let basePath = URL(string: "/person")!

    var path: URL {
        switch self {
        case let .details(personID):
            return Self.basePath
                .appendingPathComponent(personID)

        case let .combinedCredits(personID):
            return Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("combined_credits")

        case let .movieCredits(personID):
            return Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("movie_credits")

        case let .tvSeriesCredits(personID):
            return Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("tv_credits")

        case let .images(personID):
            return Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("images")

        case let .popular(page):
            return Self.basePath
                .appendingPathComponent("popular")
                .appendingPage(page)
        }
    }

}
