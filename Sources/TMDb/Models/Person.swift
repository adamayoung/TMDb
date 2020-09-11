import Foundation

public struct Person: Identifiable, Decodable, Equatable {

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
    public let imdbId: String?
    public let homepage: URL?

    public init(id: Int, name: String, alsoKnownAs: [String]? = nil, knownForDepartment: String? = nil,
                biography: String? = nil, birthday: Date? = nil, deathday: Date? = nil, gender: Gender? = nil,
                placeOfBirth: String? = nil, profilePath: URL? = nil, popularity: Float? = nil, imdbId: String? = nil,
                homepage: URL? = nil) {
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
        self.imdbId = imdbId
        self.homepage = homepage
    }

}
