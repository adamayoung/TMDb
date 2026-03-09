//
//  CrewMember.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a crew member.
///
public struct CrewMember: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Crew member's identifier.
    ///
    public let id: Int

    ///
    /// Crew member's identifier for the particular movie or TV series.
    ///
    public let creditID: String

    ///
    /// Crew member's name.
    ///
    public let name: String

    ///
    /// Crew member's original name.
    ///
    public let originalName: String?

    ///
    /// Crew member's job.
    ///
    public let job: String

    ///
    /// Crew member's department.
    ///
    public let department: String

    ///
    /// Department this crew member is known for.
    ///
    public let knownForDepartment: String?

    ///
    /// Crew member's gender.
    ///
    public let gender: Gender

    ///
    /// Crew member's profile image.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let profilePath: URL?

    ///
    /// Crew member's current popularity.
    ///
    public let popularity: Double?

    ///
    /// Is adult only content.
    ///
    public let isAdultOnly: Bool?

    ///
    /// Creates a crew member object.
    ///
    /// - Parameters:
    ///    - id: Crew member's identifier.
    ///    - creditID: Crew member's identifier for the particular movie or TV series.
    ///    - name: Crew member's name.
    ///    - originalName: Crew member's original name.
    ///    - job: Crew member's job.
    ///    - department: Crew member's department.
    ///    - knownForDepartment: Department this crew member is known for.
    ///    - gender: Crew member's gender.
    ///    - profilePath: Crew member's profile image.
    ///    - popularity: Crew member's current popularity.
    ///    - isAdultOnly: Is adult only content.
    ///
    public init(
        id: Int,
        creditID: String,
        name: String,
        originalName: String? = nil,
        job: String,
        department: String,
        knownForDepartment: String? = nil,
        gender: Gender = .unknown,
        profilePath: URL? = nil,
        popularity: Double? = nil,
        isAdultOnly: Bool? = nil
    ) {
        self.id = id
        self.creditID = creditID
        self.name = name
        self.originalName = originalName
        self.job = job
        self.department = department
        self.knownForDepartment = knownForDepartment
        self.gender = gender
        self.profilePath = profilePath
        self.popularity = popularity
        self.isAdultOnly = isAdultOnly
    }

}

extension CrewMember {

    private enum CodingKeys: String, CodingKey {
        case id
        case creditID = "creditId"
        case name
        case originalName
        case job
        case department
        case knownForDepartment
        case gender
        case profilePath
        case popularity
        case isAdultOnly = "adult"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.creditID = try container.decode(String.self, forKey: .creditID)
        self.name = try container.decode(String.self, forKey: .name)
        self.originalName = try container.decodeIfPresent(
            String.self, forKey: .originalName
        )
        self.job = try container.decode(String.self, forKey: .job)
        self.department = try container.decode(String.self, forKey: .department)
        self.knownForDepartment = try container.decodeIfPresent(
            String.self, forKey: .knownForDepartment
        )
        self.gender = (try? container.decodeIfPresent(
            Gender.self, forKey: .gender
        )) ?? .unknown
        self.profilePath = try container.decodeIfPresent(
            URL.self, forKey: .profilePath
        )
        self.popularity = try container.decodeIfPresent(
            Double.self, forKey: .popularity
        )
        self.isAdultOnly = try container.decodeIfPresent(
            Bool.self, forKey: .isAdultOnly
        )
    }

}
