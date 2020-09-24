import Foundation

public struct PersonImageCollectionDTO: Identifiable, Decodable, Equatable {

    public let id: Int
    public let profiles: [ImageMetadataDTO]

}
