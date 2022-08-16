import Foundation

public struct WatchProvider: Identifiable, Decodable, Equatable, Hashable {

    /// Watch Provider identifier.
    public let id: Int
    /// Watch Provider Name.
    public let name: String
    /// Watch Provider logo path.
    public let logoPath: URL

    /// Creates a new `WatchProvider`.
    ///
    /// - Parameters:
    ///    - id: Watch Provider identifier.
    ///    - name: Watch Provider name.
    ///    - logoPath: Watch Provider logo path.
    public init(id: Int, name: String, logoPath: URL) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
    }

}

extension WatchProvider {

    private enum CodingKeys: String, CodingKey {
        case id = "providerId"
        case name = "providerName"
        case logoPath

    }

}
