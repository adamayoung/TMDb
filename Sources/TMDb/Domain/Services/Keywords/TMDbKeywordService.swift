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

    func details(forKeyword id: Keyword.ID) async throws -> Keyword {
        let request = KeywordRequest(id: id)

        let keyword: Keyword
        do {
            keyword = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return keyword
    }

    func movies(forKeyword keywordID: Keyword.ID, page: Int?, language: String?) async throws
    -> MoviePageableList {
        let request = KeywordMoviesRequest(id: keywordID, page: page, language: language)

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

}
