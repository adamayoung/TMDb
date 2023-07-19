import Foundation

///
/// A model representing a video size.
///
public enum VideoSize: Int, Codable, Equatable, Hashable {

    ///
    /// 360.
    ///
    case s360 = 360

    ///
    /// 480.
    ///
    case s480 = 480

    ///
    /// 720.
    ///
    case s720 = 720

    ///
    /// 1080.
    ///
    case s1080 = 1080

    ///
    /// Unknown.
    ///
    case unknown

    public init(from decoder: Decoder) throws {
        self = try VideoSize(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }

}
