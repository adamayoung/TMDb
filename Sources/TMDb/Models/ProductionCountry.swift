import Foundation

/// Production country.
public struct ProductionCountry: Identifiable, Decodable, Equatable, Hashable {

    public var id: String { iso31661 }
    /// Country code.
    public let iso31661: String
    /// Country name.
    public let name: String

    /// Creates a new `ProductionCountry`.
    ///
    /// - Parameters:
    ///    - iso31661: Country code.
    ///    - name: Country name.
    public init(iso31661: String, name: String) {
        self.iso31661 = iso31661
        self.name = name
    }

}
