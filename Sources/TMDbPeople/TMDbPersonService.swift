//
//  TMDbPersonService.swift
//  TMDbPeople
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbPersonService {

  private let apiClient: APIClient

  public init(apiClient: APIClient) {
    self.apiClient = apiClient
  }

}

extension TMDbPersonService: PersonService {

  public func fetch(id: Int) -> AnyPublisher<Person, Error> {
    apiClient.get(endpoint: .person(personID: id))
  }

  public func fetchTrending(timeWindow: TrendingTimeWindowFilterType,
                            page: Int?) -> AnyPublisher<PersonPageableListResult, Error> {
    apiClient.get(endpoint: .trending(timeWindow: timeWindow, page: page))
  }

}
