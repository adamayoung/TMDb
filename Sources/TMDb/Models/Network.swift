import Foundation

/// A TV network.
public struct Network: Identifiable, Decodable, Equatable, Hashable, LogoURLProviding {

    /// Network identifier.
    public let id: Int
    /// Network name.
    public let name: String
    /// Network logo path.
    public let logoPath: URL?
    /// Network origin country.
    public let originCountry: String?

    /// Creates a new `Network`.
    ///
    /// - Parameters:
    ///    - id: Network identifier.
    ///    - name: Network name.
    ///    - logoPath: Network logo path.
    ///    - originCountry: Network origin country.
    public init(id: Int, name: String, logoPath: URL? = nil, originCountry: String? = nil) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
        self.originCountry = originCountry
    }

}
