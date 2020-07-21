//
//  PeopleEndpoint.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum PeopleEndpoint {

    case trending(timeWindow: TrendingTimeWindowFilterType, page: Int?)
    case person(personID: Int)
    case search(query: String, page: Int?)

}

extension PeopleEndpoint: Endpoint {

    var url: URL {
        switch self {
        case .trending(let timeWindow, let page):
            return URL(string: "/trending/person/\(timeWindow)")!
                .appendingPage(page)

        case .person(let personID):
            return URL(string: "/person/\(personID)")!

        case .search(let query, let page):
            return URL(string: "/search/person")!
                .appendingQueryItem(name: "query", value: query)
                .appendingPage(page)
        }
    }

}
