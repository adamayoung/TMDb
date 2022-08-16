import Foundation

/// A production company.
public struct Company: Identifiable, Decodable, Equatable, Hashable {

    /// Company identifier.
    public let id: Int
    /// Company name.
    public let name: String
    /// Description of company.
    public let description: String
    /// Location of the company's headquarters.
    public let headquarters: String
    /// Company's homepage.
    public let homepage: URL
    /// Company's logo path.
    public let logoPath: URL
    /// Origin country.
    public let originCountry: String
    /// Parent company.
    public let parentCompany: Parent?

    /// Creates a new `Company`.
    ///
    /// - Parameters:
    ///   - id: Company identifier.
    ///   - name: Company name.
    ///   - description: Description of company.
    ///   - headquarters: Location of the company's headquarters.
    ///   - homepage: Company's homepage.
    ///   - logoPath: Company's logo path.
    ///   - originCountry: Origin country.
    ///   - parentCompany: Parent company.
    public init(id: Int, name: String, description: String, headquarters: String, homepage: URL, logoPath: URL,
                originCountry: String, parentCompany: Parent? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.headquarters = headquarters
        self.homepage = homepage
        self.logoPath = logoPath
        self.originCountry = originCountry
        self.parentCompany = parentCompany
    }

}

extension Company {

    public struct Parent: Identifiable, Decodable, Equatable, Hashable {

        /// Company identifier.
        public let id: Company.ID
        /// Company name.
        public let name: String
        /// Company's logo path.
        public let logoPath: URL

        /// Creates a new `Parent` company.
        ///
        /// - Parameters:
        ///   - id: Company identifier.
        ///   - name: Company name.
        ///   - logoPath: Company's logo path.
        public init(id: Company.ID, name: String, logoPath: URL) {
            self.id = id
            self.name = name
            self.logoPath = logoPath
        }

    }

}
