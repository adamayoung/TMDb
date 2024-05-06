//
//  CrewJob.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
