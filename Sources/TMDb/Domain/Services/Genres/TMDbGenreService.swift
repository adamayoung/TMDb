//
//  TMDbGenreService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for obtaining movie and TV series genres from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbGenreService: GenreService {

    private let apiClient: any APIClient
    private let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func movieGenres(language: String? = nil) async throws -> [Genre] {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieGenresRequest(language: languageCode)

        let genreList: GenreList
        do {
            genreList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return genreList.genres
    }

    func tvSeriesGenres(language: String? = nil) async throws -> [Genre] {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesGenresRequest(language: languageCode)

        let genreList: GenreList
        do {
            genreList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return genreList.genres
    }

}
