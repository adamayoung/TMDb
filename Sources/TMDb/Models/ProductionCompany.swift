import Foundation

/// A production company.
public struct ProductionCompany: Identifiable, Decodable, Equatable, Hashable, LogoURLProviding {

    /// Production company identifier.
    public let id: Int
    /// Production company's name.
    public let name: String
    /// Production company's country of origin.
    public let originCountry: String
    /// Production company's logo path.
    public let logoPath: URL?

    /// Creates a new `ProductionCompany`.
    ///
    /// - Parameters:
    ///    - id: Production company identifier.
    ///    - name: Production company's country of origin.
    ///    - originCountry: Production company's country of origin.
    ///    - logoPath: Production company's logo path.
    public init(id: Int, name: String, originCountry: String, logoPath: URL? = nil) {
        self.id = id
        self.name = name
        self.originCountry = originCountry
        self.logoPath = logoPath
    }

}
