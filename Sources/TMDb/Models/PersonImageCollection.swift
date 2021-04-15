import Foundation

public struct PersonImageCollection: Identifiable, Decodable, Equatable {

    public let id: Int
    public let profiles: [ImageMetadata]

}
