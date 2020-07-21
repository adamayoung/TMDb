//
//  TMDbPersonService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbPersonService {

    private let apiClient: APIClient

    public init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

}

extension TMDbPersonService: PersonService {

    public func fetch(id: Int) -> AnyPublisher<Person, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.person(personID: id))
    }

    public func fetchTrending(timeWindow: TrendingTimeWindowFilterType, page: Int?) -> AnyPublisher<PersonPageableListResult, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.trending(timeWindow: timeWindow, page: page))
    }

    public func search(query: String, page: Int?) -> AnyPublisher<PersonPageableListResult, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.search(query: query, page: page))
    }

}
