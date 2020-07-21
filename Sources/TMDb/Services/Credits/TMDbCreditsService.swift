//
//  TMDbCreditsService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbCreditsService {

    private let apiClient: APIClient

    public init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

}

extension TMDbCreditsService: CreditsService {

    public func fetch(forMovie movieID: Int) -> AnyPublisher<Credits, TMDbError> {
        apiClient.get(endpoint: CreditsEndpoint.movieCredits(movieID: movieID))
    }

    public func fetch(forTVShow tvShowID: Int) -> AnyPublisher<Credits, TMDbError> {
        apiClient.get(endpoint: CreditsEndpoint.tvShowCredits(tvShowID: tvShowID))
    }

}
