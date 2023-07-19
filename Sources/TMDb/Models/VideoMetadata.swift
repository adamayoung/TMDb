import Foundation

///
/// A model representing details of a video.
///
public struct VideoMetadata: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Video identifier.
    ///
    public let id: String

    ///
    /// Video name.
    ///
    public let name: String

    ///
    /// Site which the video is from.
    ///
    public let site: String

    ///
    /// Site's video identifier.
    ///
    public let key: String

    ///
    /// Video type.
    ///
    public let type: VideoType

    ///
    /// Video size.
    ///
    public let size: VideoSize

    ///
    /// Creates a video metadata object.
    ///
    /// - Parameters:
    ///    - id: Video identifier.
    ///    - name: Video name.
    ///    - site: Site which the video is from.
    ///    - key: Site's video identifier.
    ///    - type: Video type.
    ///    - size: Video size.
    ///
    public init(
        id: String,
        name: String,
        site: String,
        key: String,
        type: VideoType,
        size: VideoSize
    ) {
        self.id = id
        self.name = name
        self.site = site
        self.key = key
        self.type = type
        self.size = size
    }

}
