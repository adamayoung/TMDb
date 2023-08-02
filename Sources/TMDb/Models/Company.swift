import Foundation

///
/// A model representing  a production company.
///
public struct Company: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Company identifier.
    ///
    public let id: Int

    ///
    /// Company name.
    ///
    public let name: String

    ///
    /// Description of company.
    ///
    public let description: String

    ///
    /// Location of the company's headquarters.
    ///
    public let headquarters: String

    ///
    /// Company's homepage.
    ///
    public let homepage: URL

    ///
    /// Company's logo path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let logoPath: URL

    ///
    /// Origin country.
    ///
    public let originCountry: String

    ///
    /// Parent company.
    ///
    public let parentCompany: Parent?

    ///
    /// Creates a company object.
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
    ///
    public init(
        id: Int,
        name: String,
        description: String,
        headquarters: String,
        homepage: URL,
        logoPath: URL,
        originCountry: String,
        parentCompany: Parent? = nil
    ) {
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

    ///
    /// A model representing a parent company.
    ///
    public struct Parent: Identifiable, Codable, Equatable, Hashable {

        ///
        /// Company identifier.
        ///
        public let id: Company.ID

        ///
        /// Company name.
        ///
        public let name: String

        ///
        /// Company's logo path.
        ///
        /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
        ///
        public let logoPath: URL

        ///
        /// Creates a parent company object.
        ///
        /// - Parameters:
        ///   - id: Company identifier.
        ///   - name: Company name.
        ///   - logoPath: Company's logo path.
        /// 
        public init(
            id: Company.ID,
            name: String,
            logoPath: URL
        ) {
            self.id = id
            self.name = name
            self.logoPath = logoPath
        }

    }

}
