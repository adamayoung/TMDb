import Foundation

///
/// A model representing a person.
///
public struct Person: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Person identifier.
    ///
    public let id: Int

    ///
    /// Person's name.
    ///
    public let name: String

    ///
    /// Person also known as.
    ///
    public let alsoKnownAs: [String]?

    ///
    /// Department this person is known for.
    ///
    public let knownForDepartment: String?

    ///
    /// Person's biography.
    ///
    public let biography: String?

    ///
    /// Person's birthday.
    ///
    public let birthday: Date?

    ///
    /// Person's death day, if they've died.
    ///
    public let deathday: Date?

    ///
    /// Person's gender.
    ///
    public let gender: Gender

    ///
    /// Person's place of birth.
    ///
    public let placeOfBirth: String?

    ///
    /// Person's profile path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let profilePath: URL?

    ///
    /// Person's current popularity.
    ///
    public let popularity: Double?

    ///
    /// Person's IMDb identifier.
    ///
    public let imdbID: String?

    ///
    /// Person's web site.
    ///
    public let homepageURL: URL?

    ///
    /// Creates a person object.
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
    ///
    public init(
        id: Int,
        name: String,
        alsoKnownAs: [String]? = nil,
        knownForDepartment: String? = nil,
        biography: String? = nil,
        birthday: Date? = nil,
        deathday: Date? = nil,
        gender: Gender,
        placeOfBirth: String? = nil,
        profilePath: URL? = nil,
        popularity: Double? = nil,
        imdbID: String? = nil,
        homepageURL: URL? = nil
    ) {
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
        self.homepageURL = homepageURL
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
        case homepageURL = "homepage"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let container2 = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.alsoKnownAs = try container.decodeIfPresent([String].self, forKey: .alsoKnownAs)
        self.knownForDepartment = try container.decodeIfPresent(String.self, forKey: .knownForDepartment)
        self.biography = try container.decodeIfPresent(String.self, forKey: .biography)
        self.birthday = try container.decodeIfPresent(Date.self, forKey: .birthday)
        self.deathday = try container.decodeIfPresent(Date.self, forKey: .deathday)
        self.gender = (try? container.decodeIfPresent(Gender.self, forKey: .gender)) ?? .unknown
        self.placeOfBirth = try container.decodeIfPresent(String.self, forKey: .placeOfBirth)
        self.profilePath = try container.decodeIfPresent(URL.self, forKey: .profilePath)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.imdbID = try container.decodeIfPresent(String.self, forKey: .imdbID)

        // Need to deal with empty strings - URL decoding will fail with an empty string
        let homepageURLString = try container.decodeIfPresent(String.self, forKey: .homepageURL)
        self.homepageURL = try {
            guard let homepageURLString, !homepageURLString.isEmpty else {
                return nil
            }

            return try container2.decodeIfPresent(URL.self, forKey: .homepageURL)
        }()
    }

}
