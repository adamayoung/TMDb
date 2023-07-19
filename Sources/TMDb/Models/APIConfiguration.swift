import Foundation

///
/// A model representing the API configuration.
///
/// Some elements of the API require some knowledge of this configuration data. The purpose of this is to try and keep
/// the actual API responses as light as possible. It is recommended you cache this data within your application and
/// check for updates every few days.
///
public struct APIConfiguration: Codable, Equatable, Hashable {

    ///
    /// Images configuration.
    ///
    public let images: ImagesConfiguration
    ///
    /// Change keys.
    ///
    public let changeKeys: [String]

    ///
    /// Creates an API configuration object.
    ///
    /// - Parameters:
    ///    - images: Images configuration.
    ///    - changeKeys: Change keys.
    ///
    public init(images: ImagesConfiguration, changeKeys: [String]) {
        self.images = images
        self.changeKeys = changeKeys
    }

}
