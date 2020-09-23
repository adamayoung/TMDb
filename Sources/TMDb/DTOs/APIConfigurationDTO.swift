import Foundation

public struct APIConfigurationDTO: Decodable, Equatable {

    public let images: ImagesConfigurationDTO
    public let changeKeys: [String]

    public init(images: ImagesConfigurationDTO, changeKeys: [String]) {
        self.images = images
        self.changeKeys = changeKeys
    }

}
