//
//  PersonService+Pagination.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Auto-pagination extensions for ``PersonService``.
///
/// These methods provide lazy `AsyncSequence`-based iteration over paginated person endpoints,
/// eliminating the need for manual pagination logic.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension PersonService {

    // MARK: - Item-Level Iteration

    ///
    /// Returns an async sequence of all popular people across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - People Lists: Popular](https://developer.themoviedb.org/reference/person-popular-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured
    /// default language.
    ///
    /// - Returns: An async sequence that yields individual ``PersonListItem`` objects.
    ///
    func allPopular(
        language: String? = nil
    ) -> PagedAsyncSequence<PersonListItem> {
        PagedAsyncSequence { [self] page in
            try await popular(page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all tagged images for a person across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - People: Tagged Images](https://developer.themoviedb.org/reference/person-tagged-images)
    ///
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Returns: An async sequence that yields individual ``TaggedImage`` objects.
    ///
    func allTaggedImages(
        forPerson personID: Person.ID
    ) -> PagedAsyncSequence<TaggedImage> {
        PagedAsyncSequence { [self] page in
            try await taggedImages(forPerson: personID, page: page)
        }
    }

    // MARK: - Page-Level Iteration

    ///
    /// Returns an async sequence of all popular people pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - People Lists: Popular](https://developer.themoviedb.org/reference/person-popular-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured
    /// default language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``PersonListItem`` objects.
    ///
    func allPopularPages(
        language: String? = nil
    ) -> PagedPagesAsyncSequence<PersonListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await popular(page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all tagged image pages for a person.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - People: Tagged Images](https://developer.themoviedb.org/reference/person-tagged-images)
    ///
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TaggedImage`` objects.
    ///
    func allTaggedImagesPages(
        forPerson personID: Person.ID
    ) -> PagedPagesAsyncSequence<TaggedImage> {
        PagedPagesAsyncSequence { [self] page in
            try await taggedImages(forPerson: personID, page: page)
        }
    }

}
