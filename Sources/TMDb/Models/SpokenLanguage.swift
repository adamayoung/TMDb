import Foundation

public struct SpokenLanguage: Identifiable, Decodable {

    public let iso6391: String
    public let name: String

    public var id: String {
        iso6391
    }

    public init(iso6391: String, name: String) {
        self.iso6391 = iso6391
        self.name = name
    }

}
