//
//  TMDbImageService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

final public class TMDbImageService {

    private let apiClient: APIClient

    public init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

}

extension TMDbImageService: ImageService {

    public func fetch(forMovie movieID: Int) -> AnyPublisher<ImageCollection, TMDbError> {
        apiClient.get(endpoint: ImagesEndpoint.movieImages(movieID: movieID))
    }

    public func fetch(forTVShow tvShowID: Int) -> AnyPublisher<ImageCollection, TMDbError> {
        apiClient.get(endpoint: ImagesEndpoint.tvShowImages(tvShowID: tvShowID))
    }

    public func fetch(forTVShow tvShowID: Int, seasonNumber: Int) -> AnyPublisher<ImageCollection, TMDbError> {
        apiClient.get(endpoint: ImagesEndpoint.tvShowSeasonImages(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }

    public func fetch(forPerson personID: Int) -> AnyPublisher<PersonImageCollection, TMDbError> {
        apiClient.get(endpoint: ImagesEndpoint.personImages(personID: personID))
    }

}
