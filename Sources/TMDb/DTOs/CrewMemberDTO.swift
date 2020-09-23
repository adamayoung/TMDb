import Foundation

public struct CrewMemberDTO: Identifiable, Decodable, Equatable, ProfileURLProviding {

    public let id: Int
    public let creditID: String
    public let name: String
    public let job: String
    public let department: String
    public let gender: GenderDTO?
    public let profilePath: URL?

    public init(id: Int, creditID: String, name: String, job: String, department: String, gender: GenderDTO? = nil,
                profilePath: URL? = nil) {
        self.id = id
        self.creditID = creditID
        self.name = name
        self.job = job
        self.department = department
        self.gender = gender
        self.profilePath = profilePath
    }

}

extension CrewMemberDTO {

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
