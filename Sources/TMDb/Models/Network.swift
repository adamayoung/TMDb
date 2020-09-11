import Foundation

public struct Network: Identifiable, Decodable, Equatable {

    public let id: Int
    public let name: String
    public let logoPath: URL?
    public let originCountry: String?

    public init(id: Int, name: String, logoPath: URL? = nil, originCountry: String? = nil) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
        self.originCountry = originCountry
    }

}
