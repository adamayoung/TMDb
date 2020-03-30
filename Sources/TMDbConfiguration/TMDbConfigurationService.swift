//
//  TMDbConfigurationService.swift
//  TMDbConfiguration
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbConfigurationService {

  private var configuration: Configuration?

  private let apiClient: APIClient

  public init(apiClient: APIClient) {
    self.apiClient = apiClient
  }

}

extension TMDbConfigurationService: ConfigurationService {

  public func fetch() -> AnyPublisher<Configuration, Error> {
    apiClient.get(endpoint: .configuration)
  }

}
