//
//  TMDbFindService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbFindService: FindService {

    private let apiClient: any APIClient
    private let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func find(
        externalID: String,
        externalSource: ExternalSource,
        language: String? = nil
    ) async throws(TMDbError) -> FindResults {
        let languageCode = language ?? configuration.defaultLanguage
        let request = FindByIDRequest(
            externalID: externalID,
            externalSource: externalSource,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

}
