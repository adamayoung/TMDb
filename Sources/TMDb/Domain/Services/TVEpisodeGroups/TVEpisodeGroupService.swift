//
//  TVEpisodeGroupService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for obtaining TV episode group data
/// from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol TVEpisodeGroupService: Sendable {

    ///
    /// Returns a TV episode group's details.
    ///
    /// [TMDb API - TV Episode Groups: Details](https://developer.themoviedb.org/reference/tv-episode-group-details)
    ///
    /// - Parameter id: The identifier of the TV episode group.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV episode group.
    ///
    func details(
        forTVEpisodeGroup id: TVEpisodeGroup.ID
    ) async throws -> TVEpisodeGroup

}
