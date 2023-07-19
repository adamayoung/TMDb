import Foundation

///
/// A model representing a country.
///
public struct Country: Identifiable, Decodable, Equatable, Hashable {

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
    /// Country name in English.
    ///
    public let englishName: String

    /// Creates a country object.
    ///
    /// - Parameters:
    ///    - countryCode: ISO 3166-1 country code.
    ///    - name: Country name.
    ///    - englishName: Country name in English.
    ///
    public init(countryCode: String, name: String, englishName: String) {
        self.countryCode = countryCode
        self.name = name
        self.englishName = englishName
    }

}

extension Country {

    private enum CodingKeys: String, CodingKey {
        case countryCode = "iso31661"
        case name = "nativeName"
        case englishName = "englishName"
    }

}
