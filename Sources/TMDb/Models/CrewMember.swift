import Foundation

///
/// A model representing a crew member..
///
public struct CrewMember: Identifiable, Codable, Equatable, Hashable {

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
    /// Crew member's job.
    ///
    public let job: String

    ///
    /// Crew member's department.
    ///
    public let department: String

    ///
    /// Crew member's gender.
    ///
    public let gender: Gender?

    ///
    /// Crew member's profile image.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let profilePath: URL?

    ///
    /// Creates a crew member object.
    ///
    /// - Parameters:
    ///    - id: Crew member's identifier.
    ///    - creditID: Crew member's identifier for the particular movie or TV series.
    ///    - name: Crew member's name.
    ///    - job: Crew member's job.
    ///    - department: Crew member's department.
    ///    - gender: Crew member's gender.
    ///    - profilePath: Crew member's profile image.
    ///
    public init(
        id: Int,
        creditID: String,
        name: String,
        job: String,
        department: String,
        gender: Gender? = nil,
        profilePath: URL? = nil
    ) {
        self.id = id
        self.creditID = creditID
        self.name = name
        self.job = job
        self.department = department
        self.gender = gender
        self.profilePath = profilePath
    }

}

extension CrewMember {

    private enum CodingKeys: String, CodingKey {
        case id
        case creditID = "creditId"
        case name
        case job
        case department
        case gender
        case profilePath
    }

}
