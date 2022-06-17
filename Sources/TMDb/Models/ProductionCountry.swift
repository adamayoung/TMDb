import Foundation

/// Production country.
public struct ProductionCountry: Identifiable, Decodable, Equatable, Hashable {

    public var id: String { countryCode }
    /// ISO 3166-1 country code.
    public let countryCode: String
    /// Country name.
    public let name: String

    /// Creates a new `ProductionCountry`.
    ///
    /// - Parameters:
    ///    - countryCode: ISO 3166-1 country code.
    ///    - name: Country name.
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
