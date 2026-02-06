//
//  TVEpisodeGroupCollection.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a collection of TV episode groups for a TV series.
///
public struct TVEpisodeGroupCollection: Identifiable, Codable, Equatable,
Hashable, Sendable {

    ///
    /// TV series identifier.
    ///
    public let id: Int

    ///
    /// Episode groups.
    ///
    public let episodeGroups: [TVEpisodeGroup]

    ///
    /// Creates a TV episode group collection object.
    ///
    /// - Parameters:
    ///    - id: TV series identifier.
    ///    - episodeGroups: Episode groups.
    ///
    public init(
        id: Int,
        episodeGroups: [TVEpisodeGroup]
    ) {
        self.id = id
        self.episodeGroups = episodeGroups
    }

}

extension TVEpisodeGroupCollection {

    private enum CodingKeys: String, CodingKey {
        case id
        case episodeGroups = "results"
    }

}
