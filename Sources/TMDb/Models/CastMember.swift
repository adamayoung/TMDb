import Foundation

public struct CastMember: Identifiable, Decodable {

    public let id: Int
    public let castID: Int?
    public let creditID: String
    public let name: String
    public let character: String
    public let gender: Gender?
    public let profilePath: URL?
    public let order: Int

    public init(id: Int, castID: Int? = nil, creditID: String, name: String, character: String, gender: Gender? = nil,
                profilePath: URL? = nil, order: Int) {
        self.id = id
        self.castID = castID
        self.creditID = creditID
        self.name = name
        self.character = character
        self.gender = gender
        self.profilePath = profilePath
        self.order = order
    }

}

extension CastMember {

    private enum CodingKeys: String, CodingKey {
        case id
        case castID = "castId"
        case creditID = "creditId"
        case name
        case character
        case gender
        case profilePath
        case order
    }

}
