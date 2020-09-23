import Foundation

public struct ImageCollectionDTO: Decodable, Equatable {

    public let id: Int
    public let posters: [ImageMetadataDTO]
    public let backdrops: [ImageMetadataDTO]

    public init(id: Int, posters: [ImageMetadataDTO], backdrops: [ImageMetadataDTO]) {
        self.id = id
        self.posters = posters
        self.backdrops = backdrops
    }

}
