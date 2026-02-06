//
//  TVEpisodeGroup.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TV episode group.
///
public struct TVEpisodeGroup: Identifiable, Codable, Equatable,
Hashable, Sendable {

    ///
    /// TV episode group identifier.
    ///
    public let id: String

    ///
    /// TV episode group name.
    ///
    public let name: String

    ///
    /// TV episode group description.
    ///
    public let description: String?

    ///
    /// Number of episodes in the group.
    ///
    public let episodeCount: Int?

    ///
    /// Number of groups.
    ///
    public let groupCount: Int?

    ///
    /// TV episode group type.
    ///
    public let type: Int?

    ///
    /// Network associated with the episode group.
    ///
    public let network: Network?

    ///
    /// Groups of episodes.
    ///
    public let groups: [Group]?

    ///
    /// Creates a TV episode group object.
    ///
    /// - Parameters:
    ///    - id: TV episode group identifier.
    ///    - name: TV episode group name.
    ///    - description: TV episode group description.
    ///    - episodeCount: Number of episodes in the group.
    ///    - groupCount: Number of groups.
    ///    - type: TV episode group type.
    ///    - network: Network associated with the episode group.
    ///    - groups: Groups of episodes.
    ///
    public init(
        id: String,
        name: String,
        description: String? = nil,
        episodeCount: Int? = nil,
        groupCount: Int? = nil,
        type: Int? = nil,
        network: Network? = nil,
        groups: [Group]? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.episodeCount = episodeCount
        self.groupCount = groupCount
        self.type = type
        self.network = network
        self.groups = groups
    }

}

public extension TVEpisodeGroup {

    ///
    /// A model representing a group within a TV episode group.
    ///
    struct Group: Identifiable, Codable, Equatable, Hashable,
    Sendable {

        ///
        /// Group identifier.
        ///
        public let id: String

        ///
        /// Group name.
        ///
        public let name: String?

        ///
        /// Group order.
        ///
        public let order: Int?

        ///
        /// Episodes in this group.
        ///
        public let episodes: [TVEpisode]?

        ///
        /// Whether the group is locked.
        ///
        public let locked: Bool?

        ///
        /// Creates a group object.
        ///
        /// - Parameters:
        ///    - id: Group identifier.
        ///    - name: Group name.
        ///    - order: Group order.
        ///    - episodes: Episodes in this group.
        ///    - locked: Whether the group is locked.
        ///
        public init(
            id: String,
            name: String? = nil,
            order: Int? = nil,
            episodes: [TVEpisode]? = nil,
            locked: Bool? = nil
        ) {
            self.id = id
            self.name = name
            self.order = order
            self.episodes = episodes
            self.locked = locked
        }

    }

}
