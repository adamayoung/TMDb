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
        forCollection id: Collection.ID,
        language: String? = nil
    ) async throws -> Collection {
        let languageCode = language ?? configuration.defaultLanguage
        let request = CollectionRequest(id: id, language: languageCode)

        let collection: Collection
        do {
            collection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return collection
    }

    func images(
        forCollection collectionID: Collection.ID,
        languages: [String]? = nil
    ) async throws -> CollectionImageCollection {
        let request = CollectionImagesRequest(id: collectionID, languages: languages)

        let imageCollection: CollectionImageCollection
        do {
            imageCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    func translations(
        forCollection collectionID: Collection.ID
    ) async throws -> [CollectionTranslation] {
        let request = CollectionTranslationsRequest(id: collectionID)

        let result: CollectionTranslationsResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.translations
    }

}
