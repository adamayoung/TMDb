//
//  Endpoint.swift
//  TMDbPeople
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum Endpoint {

  case trending(timeWindow: TrendingTimeWindowFilterType, page: Int?)
  case person(personID: Int)

}

extension Endpoint {

  var url: URL {
    switch self {
    case .trending(let timeWindow, let page):
      return URL(string: "/trending/person/\(timeWindow)")!
        .appendingPageQueryItem(page)

    case .person(let personID):
      return URL(string: "/person/\(personID)")!
    }
  }

}
