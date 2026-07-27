//
//  TMDbImageService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbImageService: ImageService {

    private let store: APIConfigurationStore

    init(configurationService: some ConfigurationService) {
        self.store = APIConfigurationStore(configurationService: configurationService)
    }

    func imagesConfiguration() async throws(TMDbError) -> ImagesConfiguration {
        try await store.apiConfiguration().images
    }

    @discardableResult
    func refresh() async throws(TMDbError) -> ImagesConfiguration {
        try await store.refresh().images
    }

}
