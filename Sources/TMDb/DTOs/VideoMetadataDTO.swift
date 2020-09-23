import Foundation

public struct VideoMetadataDTO: Identifiable, Decodable, Equatable {

    public let id: String
    public let name: String
    public let site: String
    public let key: String
    public let type: VideoTypeDTO
    public let size: VideoSizeDTO

    public init(id: String, name: String, site: String, key: String, type: VideoTypeDTO, size: VideoSizeDTO) {
        self.id = id
        self.name = name
        self.site = site
        self.key = key
        self.type = type
        self.size = size
    }

}
