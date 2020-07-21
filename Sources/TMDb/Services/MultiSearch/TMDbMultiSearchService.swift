//
//  TMDbMultiSearchService.swift
//  TMDb
//
//  Created by Adam Young on 20/07/2020.
//

import Combine
import Foundation

public final class TMDbMultiSearchService {

    private let apiClient: APIClient

    public init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

}

extension TMDbMultiSearchService: MultiSearchService {

    public func search(query: String, page: Int?) -> AnyPublisher<MultiTypePageableListResult, TMDbError> {
        apiClient.get(endpoint: MultiSearchEndpoint.search(query: query, page: page))
    }

}
