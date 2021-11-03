import Foundation

/// A person.
public struct Person: Identifiable, Decodable, Equatable, Hashable, ProfileURLProviding {

    /// Person identifier.
    public let id: Int
    /// Person's name.
    public let name: String
    /// Person also known as.
    public let alsoKnownAs: [String]?
    /// Department this person is known for.
    public let knownForDepartment: String?
    /// Person's biography.
    public let biography: String?
    /// Person's birthday.
    public let birthday: Date?
    /// Person's death day, if they've died.
    public let deathday: Date?
    /// Person's gender.
    public let gender: Gender?
    /// Person's place of birth.
    public let placeOfBirth: String?
    /// Person's profile path.
    public let profilePath: URL?
    /// Person's current popularity.
    public let popularity: Double?
    /// Person's IMDb identifier.
    public let imdbID: String?
    /// Person's web site.
    public var homepageURL: URL? {
        guard let homepage = homepage else {
            return nil
        }

        return URL(string: homepage)
    }

    private let homepage: String?

    /// Creates a new `Person`.
    ///
    /// - Parameters:
    ///    - id: Person identifier.
    ///    - name: Person's name.
    ///    - alsoKnownAs: Person also known as.
    ///    - knownForDepartment: Department this person is known for.
    ///    - biography: Person's biography.
    ///    - birthday: Person's birthday.
    ///    - deathday: Person's death day, if they've died.
    ///    - gender: Person's gender.
    ///    - placeOfBirth: Person's place of birth.
    ///    - profilePath: Person's profile path.
    ///    - popularity: Person's current popularity.
    ///    - imdbID: Person's IMDb identifier.
    ///    - homepageURL: Person's web site.
    public init(id: Int, name: String, alsoKnownAs: [String]? = nil, knownForDepartment: String? = nil,
                biography: String? = nil, birthday: Date? = nil, deathday: Date? = nil, gender: Gender? = nil,
                placeOfBirth: String? = nil, profilePath: URL? = nil, popularity: Double? = nil, imdbID: String? = nil,
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
