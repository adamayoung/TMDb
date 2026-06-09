//
//  TMDbPersonService+Changes.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbPersonService {

    func changes(
        forPerson personID: Person.ID,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws(TMDbError) -> ChangeCollection {
        let request = PersonChangesRequest(
            id: personID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        return try await apiClient.perform(request)
    }

    func latest() async throws(TMDbError) -> Person {
        let request = LatestPersonRequest()

        return try await apiClient.perform(request)
    }

    func changes(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws(TMDbError) -> ChangedIDCollection {
        let request = PersonChangesListRequest(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        return try await apiClient.perform(request)
    }

}
