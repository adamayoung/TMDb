//
//  TMDbKeywordService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbKeywordService: KeywordService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func details(forKeyword id: Keyword.ID) async throws(TMDbError) -> Keyword {
        let request = KeywordRequest(id: id)

        return try await apiClient.perform(request)
    }

    func movies(
        forKeyword keywordID: Keyword.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        let request = KeywordMoviesRequest(id: keywordID, page: page, language: language)

        return try await apiClient.perform(request)
    }

}
