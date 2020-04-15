//
//  TMDbConfigurationService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public final class TMDbConfigurationService {

  private var configuration: Configuration?

  private let apiClient: APIClient

  public init(apiClient: APIClient = TMDbAPIClient.shared) {
    self.apiClient = apiClient
  }

}

extension TMDbConfigurationService: ConfigurationService {

  public func fetch() -> AnyPublisher<Configuration, TMDbError> {
    apiClient.get(endpoint: ConfigurationEndpoint.configuration)
  }

}
