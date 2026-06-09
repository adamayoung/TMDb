//
//  TMDbCompanyService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbCompanyService: CompanyService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func details(forCompany id: Company.ID) async throws(TMDbError) -> Company {
        let request = CompanyDetailsRequest(id: id)

        return try await apiClient.perform(request)
    }

    func alternativeNames(
        forCompany id: Company.ID
    ) async throws(TMDbError) -> CompanyAlternativeNameCollection {
        let request = CompanyAlternativeNamesRequest(id: id)

        return try await apiClient.perform(request)
    }

    func images(
        forCompany id: Company.ID
    ) async throws(TMDbError) -> CompanyImageCollection {
        let request = CompanyImagesRequest(id: id)

        return try await apiClient.perform(request)
    }

}
