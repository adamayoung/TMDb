import Foundation

public struct PersonImageCollection: Identifiable, Decodable, Equatable {

    public let id: Int
    public let profiles: [ImageMetadata]

    public init(id: Int, profiles: [ImageMetadata]) {
        self.id = id
        self.profiles = profiles
    }

}
