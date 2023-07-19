import Foundation

///
/// A model representing a production country.
///
public struct ProductionCountry: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Country's identifier (same as `countryCode`).
    ///
    public var id: String { countryCode }

    ///
    /// The ISO 3166-1 country code.
    ///
    public let countryCode: String

    ///
    /// Country name.
    ///
    public let name: String

    ///
    /// Creates a production country object.
    ///
    /// - Parameters:
    ///    - countryCode: ISO 3166-1 country code.
    ///    - name: Country name.
    ///
    public init(countryCode: String, name: String) {
        self.countryCode = countryCode
        self.name = name
    }

}

extension ProductionCountry {

    private enum CodingKeys: String, CodingKey {
        case countryCode = "iso31661"
        case name
    }

}
