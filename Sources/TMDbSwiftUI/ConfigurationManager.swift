//
//  File.swift
//  
//
//  Created by Adam Young on 08/04/2020.
//

import Combine
import SwiftUI
import TMDb

public final class ConfigurationManager: ObservableObject {

  static let shared = ConfigurationManager()

  private let configurationService: ConfigurationService
  private var cancellables = Set<AnyCancellable>()
  private var isFetching = false

  @Published private(set) var imagesConfiguration: ImagesConfiguration?

  private init(configurationService: ConfigurationService = TMDbConfigurationService()) {
    self.configurationService = configurationService
  }

  func fetchIfNeeded() {
    guard !isFetching, imagesConfiguration == nil else {
      return
    }

    isFetching = true

    configurationService.fetch()
      .map(\.images)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in
        self.isFetching = false
        }, receiveValue: { [weak self] imagesConfiguration in
          self?.imagesConfiguration = imagesConfiguration
      })
      .store(in: &cancellables)
  }

}
