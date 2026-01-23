//
//  CrewJob.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an aggregate crew member's job.
///
public struct CrewJob: Codable, Equatable, Hashable, Sendable {

    ///
    /// Credit identifier.
    ///
    public let creditID: String

    ///
    /// Crew member's job.
    ///
    public let job: String

    ///
    /// Number of episodes this crew member appeared in in this role.
    ///
    public let episodeCount: Int

    ///
    /// Creates an aggregate crew member's role object.
    ///
    /// - Parameters:
    ///   - creditID: Credit identifier.
    ///   - job: Crew member's job.
    ///   - episodeCount: Number of episodes this crew member appeared in in
    ///   this role.
    ///
    public init(
        creditID: String,
        job: String,
        episodeCount: Int
    ) {
        self.creditID = creditID
        self.job = job
        self.episodeCount = episodeCount
    }

}

extension CrewJob {

    private enum CodingKeys: String, CodingKey {
        case creditID = "creditId"
        case job
        case episodeCount
    }

}
