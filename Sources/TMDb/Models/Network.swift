import Foundation

///
/// A model representing a TV network.
///
public struct Network: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Network identifier.
    ///
    public let id: Int

    ///
    /// Network name.
    ///
    public let name: String

    ///
    /// Network logo path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let logoPath: URL?

    ///
    /// Network origin country.
    ///
    public let originCountry: String?

    ///
    /// Creates a network object.
    ///
    /// - Parameters:
    ///    - id: Network identifier.
    ///    - name: Network name.
    ///    - logoPath: Network logo path.
    ///    - originCountry: Network origin country.
    ///
    public init(
        id: Int,
        name: String,
        logoPath: URL? = nil,
        originCountry: String? = nil
    ) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
        self.originCountry = originCountry
    }

}
