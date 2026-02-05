//
//  TMDbPersonService+Media.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbPersonService {

    func taggedImages(
        forPerson personID: Person.ID,
        page: Int? = nil
    ) async throws -> TaggedImagePageableList {
        let request = PersonTaggedImagesRequest(
            id: personID, page: page
        )

        let taggedImageList: TaggedImagePageableList
        do {
            taggedImageList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return taggedImageList
    }

}
