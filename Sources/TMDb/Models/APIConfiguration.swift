import Foundation

public struct APIConfiguration: Decodable, Equatable {

    public let images: ImagesConfiguration
    public let changeKeys: [String]

    public init(images: ImagesConfiguration, changeKeys: [String]) {
        self.images = images
        self.changeKeys = changeKeys
    }

}
