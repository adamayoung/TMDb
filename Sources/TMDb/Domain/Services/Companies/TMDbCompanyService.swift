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

    func details(forCompany id: Company.ID) async throws -> Company {
        let request = CompanyDetailsRequest(id: id)

        let company: Company
        do {
            company = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return company
    }

    func alternativeNames(
        forCompany id: Company.ID
    ) async throws -> CompanyAlternativeNameCollection {
        let request = CompanyAlternativeNamesRequest(id: id)

        let result: CompanyAlternativeNameCollection
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result
    }

    func images(
        forCompany id: Company.ID
    ) async throws -> CompanyImageCollection {
        let request = CompanyImagesRequest(id: id)

        let result: CompanyImageCollection
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result
    }

}
