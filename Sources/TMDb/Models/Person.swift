import Foundation

public struct Person: Identifiable, Decodable, Equatable, ProfileURLProviding {

    public let id: Int
    public let name: String
    public let alsoKnownAs: [String]?
    public let knownForDepartment: String?
    public let biography: String?
    public let birthday: Date?
    public let deathday: Date?
    public let gender: Gender?
    public let placeOfBirth: String?
    public let profilePath: URL?
    public let popularity: Float?
    public let imdbID: String?

    private let homepage: String?

    public init(id: Int, name: String, alsoKnownAs: [String]? = nil, knownForDepartment: String? = nil,
                biography: String? = nil, birthday: Date? = nil, deathday: Date? = nil, gender: Gender? = nil,
                placeOfBirth: String? = nil, profilePath: URL? = nil, popularity: Float? = nil, imdbID: String? = nil,
                homepageURL: URL? = nil) {
        self.id = id
        self.name = name
        self.alsoKnownAs = alsoKnownAs
        self.knownForDepartment = knownForDepartment
        self.biography = biography
        self.birthday = birthday
        self.deathday = deathday
        self.gender = gender
        self.placeOfBirth = placeOfBirth
        self.profilePath = profilePath
        self.popularity = popularity
        self.imdbID = imdbID
        self.homepage = homepageURL?.absoluteString
    }

}

extension Person {

    public var homepageURL: URL? {
        guard let homepage = homepage else {
            return nil
        }

        return URL(string: homepage)
    }

}

extension Person {

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case alsoKnownAs
        case knownForDepartment
        case biography
        case birthday
        case deathday
        case gender
        case placeOfBirth
        case profilePath
        case popularity
        case imdbID = "imdbId"
        case homepage
    }

}
