import Foundation

public struct VideoCollectionDTO: Identifiable, Decodable, Equatable {

    public let id: Int
    public let results: [VideoMetadataDTO]

    public init(id: Int, results: [VideoMetadataDTO]) {
        self.id = id
        self.results = results
    }

}
