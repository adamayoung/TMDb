//
//  TMDbCollectionService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbCollectionService: CollectionService {

    private let apiClient: any APIClient
    private let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func details(
        forCollection collectionID: Collection.ID,
        language: String? = nil
    ) async throws(TMDbError) -> Collection {
        let languageCode = language ?? configuration.defaultLanguage
        let request = CollectionRequest(id: collectionID, language: languageCode)

        return try await apiClient.perform(request)
    }

    func images(
        forCollection collectionID: Collection.ID,
        languages: [String]? = nil
    ) async throws(TMDbError) -> CollectionImageCollection {
        let request = CollectionImagesRequest(id: collectionID, languages: languages)

        return try await apiClient.perform(request)
    }

    func translations(
        forCollection collectionID: Collection.ID
    ) async throws(TMDbError) -> [CollectionTranslation] {
        let request = CollectionTranslationsRequest(id: collectionID)

        return try await apiClient.perform(request).translations
    }

}
