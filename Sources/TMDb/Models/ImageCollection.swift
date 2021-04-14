import Foundation

public struct ImageCollection: Decodable, Equatable {

    public let id: Int
    public let posters: [ImageMetadata]
    public let backdrops: [ImageMetadata]

    public init(id: Int, posters: [ImageMetadata], backdrops: [ImageMetadata]) {
        self.id = id
        self.posters = posters
        self.backdrops = backdrops
    }

}
