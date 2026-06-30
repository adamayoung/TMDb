//
//  TMDbCreditService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbCreditService: CreditService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func details(forCredit id: Credit.ID) async throws(TMDbError) -> Credit {
        try Self.validate(id: id)
        let request = CreditRequest(id: id)

        return try await apiClient.perform(request)
    }

}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbCreditService {

    private static func validate(id: Credit.ID) throws(TMDbError) {
        try id.validateNotEmpty(message: "Credit ID must not be empty")
    }

}
