//
//  AggregrateCrewMember.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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
/// A model representing an aggregate crew member.
///
public struct AggregrateCrewMember: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Person identifier.
    ///
    public let id: Int

    ///
    /// Crew member's name.
    ///
    public let name: String

    ///
    /// Crew member's original name.
    ///
    public let originalName: String

    ///
    /// Cast member's gender.
    ///
    public let gender: Gender

    ///
    /// Cast member's profile image.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let profilePath: URL?

    ///
    /// Cast member's roles.
    ///
    public let jobs: [CrewJob]

    ///
    /// Department this person is known for.
    ///
    public let knownForDepartment: String?

    ///
    /// Is adult?
    ///
    public let adult: Bool?

    ///
    /// Total episodes the crew member worked on.
    ///
    public let totalEpisodeCount: Int

    ///
    /// Cast member's popularity.
    ///
    public let popularity: Double?

    ///
    /// Creates an aggregate cast member's role object.
    ///
    /// - Parameters:
    ///   - id: Person identifier.
    ///   - name: Crew member's name.
    ///   - originalName: Crew member's original name.
    ///   - gender: Crew member's gender.
    ///   - profilePath: Crew member's profile image.
    ///   - jobs: Crew member's job.
    ///   - knownForDepartment: Department this person is known for.
    ///   - adult: Is adult?
    ///   - totalEpisodeCount: Total episodes this crew member appears in.
    ///   - popularity: Crew member's popularity.
    ///
    public init(
        id: Int,
        name: String,
        originalName: String,
        gender: Gender,
        profilePath: URL?,
        jobs: [CrewJob],
        knownForDepartment: String?,
        adult: Bool?,
        totalEpisodeCount: Int,
        popularity: Double?
    ) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.gender = gender
        self.profilePath = profilePath
        self.jobs = jobs
        self.knownForDepartment = knownForDepartment
        self.adult = adult
        self.totalEpisodeCount = totalEpisodeCount
        self.popularity = popularity
    }

}
