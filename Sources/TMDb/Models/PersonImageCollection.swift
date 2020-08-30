import Foundation

public struct PersonImageCollection: Identifiable, Decodable {

    public let id: Int
    public let profiles: [ImageMetadata]

}
