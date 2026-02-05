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
    ) async throws -> ChangeCollection {
        let request = PersonChangesRequest(
            id: personID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        let changeCollection: ChangeCollection
        do {
            changeCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return changeCollection
    }

    func latestPerson() async throws -> Person {
        let request = LatestPersonRequest()

        let person: Person
        do {
            person = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return person
    }

    func personChanges(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangedIDCollection {
        let request = PersonChangesListRequest(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        let changedIDCollection: ChangedIDCollection
        do {
            changedIDCollection = try await apiClient
                .perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return changedIDCollection
    }

}
