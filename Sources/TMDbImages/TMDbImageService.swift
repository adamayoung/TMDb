//
//  TMDbImageService.swift
//  TMDbImages
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

final public class TMDbImageService {

  private let apiClient: APIClient

  public init(apiClient: APIClient) {
    self.apiClient = apiClient
  }

}

extension TMDbImageService: ImageService {

  public func fetch(forMovie movieID: Int) -> AnyPublisher<ImageCollection, Error> {
    apiClient.get(endpoint: .movieImages(movieID: movieID))
  }

  public func fetch(forTVShow tvShowID: Int) -> AnyPublisher<ImageCollection, Error> {
    apiClient.get(endpoint: .tvShowImages(tvShowID: tvShowID))
  }

  public func fetch(forTVShow tvShowID: Int, seasonNumber: Int) -> AnyPublisher<ImageCollection, Error> {
    apiClient.get(endpoint: .tvShowSeasonImages(tvShowID: tvShowID, seasonNumber: seasonNumber))
  }

  public func fetch(forPerson personID: Int) -> AnyPublisher<PersonImageCollection, Error> {
    apiClient.get(endpoint: .personImages(personID: personID))
  }

}
